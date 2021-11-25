//
//  MessageView.swift
//  Encryptify
//
//  Created by Artur Rybak on 24/11/2021.
//

import SwiftUI
import CoreData

struct MessageView : View {
    var currentMessage: Message
    var body: some View {
        HStack() {
            if !currentMessage.user!.isCurrentUser {
                Image(currentMessage.user!.avatar ?? "default")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            } else {
                Spacer()
            }
            
            ContentMessageView(contentMessage: currentMessage.content!,
                               isCurrentUser: currentMessage.user!.isCurrentUser)
                .padding(.horizontal, 7)
        }

    }
}

struct MessageView_Previews: PreviewProvider {

    static var previews: some View {
        let user1 = User(context: PersistenceController.preview.container.viewContext)
        user1.name = "Violet Limes"
        user1.id = UUID()
        user1.avatar = "girl"

        let newMessage = Message(context: PersistenceController.preview.container.viewContext)
        newMessage.id = UUID()
        newMessage.content = "Vestibulum euismod facilisis quam, at fermentum mi interdum varius"
        newMessage.user = user1

        
        return MessageView(currentMessage: newMessage)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}
