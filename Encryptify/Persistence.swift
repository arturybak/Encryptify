//
//  Persistence.swift
//  Encryptify
//
//  Created by Artur Rybak on 25/11/2021.
//

import CoreData
import UIKit

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
        
    func getAllUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrentUser == NO")
        let sort = NSSortDescriptor(key: #keyPath(User.lastMessage.date), ascending: false)
        request.sortDescriptors = [sort]

        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getConversation(with userId: UUID) -> [Message] {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "user.id == %@", userId as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Message.date), ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }

    
    func getCurrentUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "isCurrentUser == YES")
        return try? viewContext.fetch(request).first

//        do {
//            return try viewContext.fetch(request).first
//        } catch {
//            return nil
//        }
    }
    
    func checkIfShareExists(date: Date, userId: UUID) -> [Message]? {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        let predicate1 = NSPredicate(format: "date == %@", date as NSDate)
        let predicate2 = NSPredicate(format: "isSender == NO")
        let predicate3 = NSPredicate(format: "user.id == %@", userId as CVarArg)

        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        
        return try? viewContext.fetch(request)
    }
    
    func deleteUser(user: User) {
        print("persistence - deleting \(user.name!)")
        viewContext.delete(user)
        save()
    }
    
    func deleteMessage(message: Message) {
        viewContext.delete(message)
        save()
    }

    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unable to initialize Core Data Stack \(error), \(error.userInfo)")
            }
        })
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let user1 = User(context: viewContext)
        user1.name = "Violet Limes"
        user1.id = UUID()
        let image1 = UIImage(named: "girl")
        user1.avatar = image1!.jpegData(compressionQuality: 1.0)

        
        let user2 = User(context: viewContext)
        user2.name = "Artur Rybka"
        user2.id = UUID()
        let image2 = UIImage(named: "me")
        user2.avatar = image2!.jpegData(compressionQuality: 1.0)
        user2.isCurrentUser = true
        
        for _ in 0..<4 {
            let newMessage = Message(context: viewContext)
            newMessage.id = UUID()
            newMessage.content = "Vestibulum euismod facilisis quam, at fermentum mi interdum varius"
            newMessage.user = user1
            newMessage.date = Date()
        }
        for _ in 0..<4 {
            let newMessage = Message(context: viewContext)
            newMessage.id = UUID()
            newMessage.content = "Sed in risus pharetra, tincidunt felis quis, pharetra quam"
            newMessage.user = user1
            newMessage.date = Date()
            newMessage.isSender = true
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

}
