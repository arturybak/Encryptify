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
    @Published var conversation: [Message] = []

    func getConversation(with userID: UUID) {
        conversation = PersistenceController.shared.getConversation(with: userID)
    }
    
    func delete(_ message: Message){
        PersistenceController.shared.deleteMessage(message: message)
    }

    func save(isSender: Bool = false) {
        let message = Message(context: PersistenceController.shared.viewContext)
        message.content = content
        message.user = user
        message.isSender = isSender
        
        message.id = UUID()
        message.date = Date()
        
        user?.lastMessage = message
        
        PersistenceController.shared.save()
    }
}
