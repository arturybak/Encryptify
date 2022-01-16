//
//  MessageViewModel.swift
//  Encryptify
//
//  Created by Artur Rybak on 14/01/2022.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class MessageViewModel: ObservableObject {

    //@Environment(\.managedObjectContext) private var viewContext

    var content: String = ""
    var user: User?
    //@Published var users: [User] = []
    //@Published var currentUser: User? = nil
    
//    func getAllUsers() {
//        users = PersistenceController.shared.getAllUsers()
//        print("got all users!")
//    }
//    
//    func getCurrentUser() {
//        currentUser = users.first(where: { $0.isCurrentUser == true})
//    }
//
//    func delete(_ user: User){
//        PersistenceController.shared.deleteUser(user: user)
//    }
//
//    func save(isSigningIn: Bool = false) {
//        let pickedAvatar = image!.jpegData(compressionQuality: 1.0)
//        let user = User(context: PersistenceController.shared.viewContext)
//        user.name = name
//        user.isCurrentUser = isSigningIn
//        user.avatar = pickedAvatar
//        user.id = UUID()
//
//        PersistenceController.shared.save()
//    }
}
