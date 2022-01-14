//
//  ChatView.swift
//  Encryptify
//
//  Created by Artur Rybak on 13/01/2022.
//

import SwiftUI

struct ChatView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    //@FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>
    //@FetchRequest(entity: Message.entity(), sortDescriptors: []) var messages: FetchedResults<Message>
    @ObservedObject private var userVM = UserViewModel()

    @State private var showingRegistrationForm = false
    @ViewBuilder
    var body: some View {
        NavigationView {
            if userVM.users.isEmpty {
                VStack {
                    Text("First time?")
                        .font(.title)
                        .padding(.bottom, 10.0)
                    Button(action: {showingRegistrationForm.toggle()}) {Text("Sign In").font(.title)}
                    .buttonStyle(GradientButtonStyle())
                }
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: didDismiss) {
                    UserRegistrationView()
                }

            } else if (userVM.users.count == 1) {
                VStack {
                    Text("Welcome \(userVM.currentUser ?? userVM.users[0])!")
                        .font(.title)
                        .padding(.bottom, 10.0)
                    Button(action: {showingRegistrationForm.toggle()}) {Text("Add your first Contact!").font(.title)}
                    .buttonStyle(GradientButtonStyle())
                }
            } else {
                List(userVM.users.filter {!$0.isCurrentUser}) { user in
                    Text(user.name!)
                }
                .navigationTitle(Text("Encryptify"))
            }

        }
        .onAppear(perform: {
            userVM.getAllUsers()
        })

    }
    
    func didDismiss() {
        userVM.getAllUsers()
    }
}






struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(K.Colors.gradient)
            .cornerRadius(15.0)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
