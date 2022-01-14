//
//  ConversationView.swift
//  Encryptify
//
//  Created by Artur Rybak on 24/11/2021.
//

import SwiftUI
import CoreData

struct ConversationView: View {
    @State var typingMessage: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>
    @FetchRequest(entity: Message.entity(), sortDescriptors: []) var messages: FetchedResults<Message>

    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack {
                    List {
                        ForEach(messages) { msg in
                            MessageView(currentMessage: msg)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    HStack {
                        TextField("Write your message here", text: $typingMessage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            //.frame(minHeight: CGFloat(30))
//                            .onTapGesture {
//                                proxy.scrollTo(chatHelper.realTimeMessages[chatHelper.realTimeMessages.endIndex - 1])
//                            }

                        Button(action: sendMessage) {
                            Text("Send")
                        }
                        
                    }
                    .frame(minHeight: CGFloat(30)).padding()
                //}.navigationBarTitle(Text((users.first(where: { $0.isCurrentUser == true})?.name)!), displayMode: .inline)
                }.navigationBarTitle(Text("Artur Rybka"), displayMode: .inline)

            }
//            .padding(.bottom, keyboard.currentHeight)
//            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
//        }.onTapGesture {
//                self.endEditing(true)
        }
    }
    
    private func sendMessage() {
        let newMessage = Message(context: viewContext)
        newMessage.content = typingMessage
        newMessage.user = users.first(where: { $0.isCurrentUser == true})
        do {
            try viewContext.save()
            print("Message saved.")
        } catch {
            print(error.localizedDescription)
        }
        typingMessage = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
