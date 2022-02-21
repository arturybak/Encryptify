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
    //@Published var lastMessage: Message? = nil

    func getConversation(with userID: UUID) {
        conversation = PersistenceController.shared.getConversation(with: userID)
    }
    
    func delete(_ message: Message){
        if message == conversation.last {
            if conversation.count > 1 {
                user!.lastMessage = conversation[conversation.count - 2]
            } else {
                user!.lastMessage = nil
            }
        }
        PersistenceController.shared.deleteMessage(message: message)
    }

    func save(isSender: Bool = false, date: Date) {
        var message: Message!
        
        if !isSender {
            let checkForShare = PersistenceController.shared.checkIfShareExists(date: date, userId: user!.id!)
            if checkForShare?.count == 0 {
                message = Message(context: PersistenceController.shared.viewContext)
                message.content = content
                message.sharesSoFar = 1
                message.neededNumOfShares = Int16(K.SecretSharing.threshold)
            } else {
                message = checkForShare?.first
                message.content!.append(".\(content)")
                message.sharesSoFar += 1
            }
        } else {
            message = Message(context: PersistenceController.shared.viewContext)
            message.content = content
        }
        
        message.date = date
        message.user = user
        message.isSender = isSender
        message.id = UUID()

        //lastMessage = message
        user!.lastMessage = isSender ? message : user!.lastMessage
        PersistenceController.shared.save()
    }
}
