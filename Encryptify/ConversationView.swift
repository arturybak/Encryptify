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
            ScrollViewReader { value in
                VStack {
                    if messageVM.conversation.isEmpty {
                        Spacer()
                        Text("No messages yet")
                            .font(.system(size: 30))
                            .foregroundColor(Color.gray)
                        //Spacer()
                    } else {
                        List {
                            ForEach(messageVM.conversation) { msg in
                                if msg == messageVM.conversation.last {
                                    MessageView(currentMessage: msg)
                                        .id("lastMessage")
                                        .listRowSeparator(.hidden)
                                } else {
                                    MessageView(currentMessage: msg)
                                        .listRowSeparator(.hidden)
                                }
                            }
                            .onDelete(perform: deleteMessage)
                        }
                        .listStyle(.plain)
                    }
                }
                .navigationBarTitle(Text(user.name!), displayMode: .inline)
                .onChange(of: messageVM.conversation.count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        value.scrollTo("lastMessage")}
                    }
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground))
                        .ignoresSafeArea()
//                        .onTapGesture {
//                            value.scrollTo(Self.scrollToString)
//                        }
                }
            }
        .onAppear(perform: {
            userVM.getCurrentUser()
            messageVM.getConversation(with: user.id!)
        })

    }
    
    private var chatBottomBar: some View {
        HStack {
            TextField("Write your message here", text: $typingMessage)
                .frame(height: 40)
            Button(action: sendMessage) {
                Text("Send")
            }
            .buttonStyle(K.GradientButtonStyle())
            .padding(.vertical, 7.0)
            
            
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
        
        user1.lastMessage = newMessage

        return ConversationView(user: user1)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
