//
//  MessageView.swift
//  Encryptify
//
//  Created by Artur Rybak on 24/11/2021.
//

import SwiftUI
import CoreData

struct MessageView : View {
    var msg: Message
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .bottom, spacing: 10) {
                if !msg.isSender {
                    Image(uiImage: UIImage(data: (msg.user?.avatar ?? K.Avatars.defaultAvatar)!)!)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                } else {
                    Spacer()
                }
                
                ContentMessageView(contentMessage: (!msg.isSender && msg.neededNumOfShares > 0 ? "ENCRYPTED. Need \(msg.neededNumOfShares - msg.sharesSoFar) more shares to decrypt" : msg.content ?? "")!,
                                       isCurrentUser: msg.isSender)
            }
            .fixedSize(horizontal: false, vertical: true)
            Text(msg.date!, style: .time).font(.footnote).foregroundColor(Color.gray)

//            HStack {
//                Text(msg.date!, style: .date)
//                Text(msg.date!, style: .time)
//            }.foregroundColor(Color.gray)

                //.padding(.horizontal, 7)
        }

    }
}

struct MessageView_Previews: PreviewProvider {

    static var previews: some View {
        let user1 = User(context: PersistenceController.preview.container.viewContext)
        user1.name = "Violet Limes"
        user1.id = UUID()
        //user1.avatar = "girl"
        let image1 = UIImage(named: "girl")
        user1.avatar = image1!.jpegData(compressionQuality: 1.0)
        user1.isCurrentUser = false

        let newMessage = Message(context: PersistenceController.preview.container.viewContext)
        newMessage.id = UUID()
        newMessage.content = "Vestibulum euismod facilisis quam, at fermentum mi interdum varius"
        newMessage.user = user1
        newMessage.date = Date()
        newMessage.isSender = false
        
        user1.lastMessage = newMessage
        
        return MessageView(msg: newMessage)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

    }
}
