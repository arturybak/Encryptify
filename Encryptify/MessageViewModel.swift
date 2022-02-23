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
        let _ = print("getting conversation with: \(userID)")
        conversation = PersistenceController.shared.getConversation(with: userID)
    }
    
    func decryptCompleteShares() {
        let shareSet = PersistenceController.shared.getCompleteShares()
        for shares in shareSet {
            let shareArray = shares.content!.split(separator: ".")
            let sharesObjects = shareArray.compactMap { try? Secret.Share(string: String($0)) }
            let sharesCasted = [Secret.Share](sharesObjects)

            let secretData = try!  Secret.combine(shares: sharesCasted)
            let secret = String(data: secretData, encoding: .utf8)
            print("identified a complete secret: \(secret ?? "not working")")
            
            let message = Message(context: PersistenceController.shared.viewContext)
            message.content = secret
            message.date = shares.date
            message.user = shares.user
            message.isSender = false
            message.id = UUID()
            
            if shares.user!.lastMessage == nil || shares.user!.lastMessage!.date! < message.date! {
                shares.user!.lastMessage = message
            }

            PersistenceController.shared.deleteMessage(message: shares)
        }
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
