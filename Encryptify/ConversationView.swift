//
//  ConversationView.swift
//  Encryptify
//
//  Created by Artur Rybak on 24/11/2021.
//

import SwiftUI
import CoreData

struct ConversationView: View {
    var user: User
    @State var typingMessage: String = ""
    @ObservedObject private var messageVM = MessageViewModel()
    @ObservedObject private var userVM = UserViewModel()
    
    var body: some View {
            ScrollViewReader { proxy in
                VStack {
                    if messageVM.conversation.isEmpty {
                        Spacer()
                        Text("No messages yet")
                            .font(.system(size: 30))
                            .foregroundColor(Color.gray)
                        Spacer()
                    } else {
                        List {
                            ForEach(messageVM.conversation) { msg in
                                MessageView(currentMessage: msg)
                                    .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: deleteMessage)
                        }
                        .listStyle(.plain)
                    }
                    chatBottomBar
                        //.background(Color(.init(white: 0.95, alpha: 1)).ignoresSafeArea())

                }.navigationBarTitle(Text(user.name!), displayMode: .inline)

            }
//            .padding(.bottom, keyboard.currentHeight)
//            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
//        }.onTapGesture {
//                self.endEditing(true)
        .onAppear(perform: {
            userVM.getAllUsers()
            userVM.getCurrentUser()
            messageVM.getConversation(with: user.id!)
        })

    }
    
    private var chatBottomBar: some View {
        HStack {
            TextField("Write your message here", text: $typingMessage)
                //.frame(minHeight: CGFloat(30))
//                            .onTapGesture {
//                                proxy.scrollTo(chatHelper.realTimeMessages[chatHelper.realTimeMessages.endIndex - 1])
//                            }
                .frame(height: 40)
            Button(action: sendMessage) {
                Text("Send")
            }
            .buttonStyle(K.GradientButtonStyle())
            
            
        }
        .padding(.horizontal)
        
        //.padding(.vertical, 8)
        
    }
    
    func deleteMessage(at offsets: IndexSet) {
        offsets.forEach { index in
            let message = messageVM.conversation[index]
            messageVM.delete(message)
        }
        messageVM.getConversation(with: user.id!)
    }

    private func sendMessage() {
        messageVM.content = typingMessage
        messageVM.user = user
        messageVM.save(isSender: true)
        messageVM.getConversation(with: user.id!)
        typingMessage = ""

    }
}

struct ContentView_Previews: PreviewProvider {
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

        return ConversationView(user: user1)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
