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
    @State private var typingMessage: String = ""
    @State private var showingAlert = false
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
                                //let _ = print("message: \(msg.content!) numShares: \(msg.sharesSoFar)")
                                let _ = print("message: \(msg.content!) sentOn: \(msg.date!)")
                                ZStack {
                                    MessageView(msg: msg)
                                    if msg.isSender {
                                        NavigationLink(destination: MessageShareView(message: msg)) {
                                            EmptyView()
                                        }
                                        .opacity(0)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .if(msg == messageVM.conversation.last)
                                {$0.id("lastMessage")}
                                .disabled(!msg.isSender)
                            }
                            .onDelete(perform: deleteMessage)
                        }
                        .listStyle(.plain)
                    }
                }
                //.navigationBarTitle(Text(user.name!), displayMode: .inline)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                            Text(user.name!).font(.headline)
                        }
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            print("Button pressed")
                        }, label: {
                            Image(systemName: "gear.circle.fill")
                                .font(.title)
                        })
                    }
                }
                .onChange(of: messageVM.conversation.count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        value.scrollTo("lastMessage")}
                    }
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground))
                        .ignoresSafeArea()
                }
            }
        .onAppear(perform: {
            userVM.getCurrentUser()
            messageVM.decryptCompleteShares()
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
    }
    
    func deleteMessage(at offsets: IndexSet) {
        messageVM.user = user
        offsets.forEach { index in
            let message = messageVM.conversation[index]
            messageVM.delete(message)
        }
        messageVM.getConversation(with: user.id!)
    }

    private func sendMessage() {
        messageVM.content = typingMessage
        messageVM.user = user
        
        messageVM.save(isSender: true, date: Date())
        messageVM.getConversation(with: user.id!)
        typingMessage = ""

    }
}

extension View {
  @ViewBuilder
  func `if`<Transform: View>(
    _ condition: Bool,
    transform: (Self) -> Transform
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
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
