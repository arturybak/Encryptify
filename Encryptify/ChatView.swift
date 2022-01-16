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
                    Spacer()
                    Text("First time?")
                        .font(.title2)
                    Button(action: {showingRegistrationForm.toggle()}) {Text("Sign In").font(.title).frame(maxWidth: .infinity)}
                    .padding([.top, .leading, .trailing])
                    .buttonStyle(GradientButtonStyle())

                }
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: didDismiss) {
                    UserRegistrationView(firstUser: true)
                }

            } else if (userVM.users.count == 1) {
                VStack {
                    Spacer()
                    Text("Welcome \((userVM.currentUser?.name ?? userVM.users[0].name)!)!")
                        .font(.title2)
                        .padding(.bottom, 10.0)
                    Spacer()
                    Button(action: {showingRegistrationForm.toggle()}) {Text("Add your first Contact!").font(.title).frame(maxWidth: .infinity)}
                    .padding([.top, .leading, .trailing])
                    .buttonStyle(GradientButtonStyle())
                }
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: didDismiss) {
                    UserRegistrationView()
                }

            } else {
                VStack {
                    List{
                        ForEach(userVM.users.filter {!$0.isCurrentUser}) { user in
                            NavigationLink(destination: Text(user.name!)) {
                                HStack {
                                    Image(uiImage: UIImage(data: (user.avatar ?? K.Avatars.defaultAvatar)!)!)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(20)
                                    Text(user.name!)
                                }
                            }
                        }.onDelete(perform: deleteUser)
                    }
                    Spacer()
                    Button(action: {showingRegistrationForm.toggle()}) {Text("Add Contact").font(.title).frame(maxWidth: .infinity)}
                    .padding([.top, .leading, .trailing])
                    .buttonStyle(GradientButtonStyle())

                }
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: didDismiss) {
                    UserRegistrationView()
                }
            }

        }
        .onAppear(perform: {
            userVM.getAllUsers()
            userVM.getCurrentUser()
        })

    }
    
    func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = userVM.users[index + 1] // because of filtering
            userVM.delete(user)
        }
        userVM.getAllUsers()
    }
    
    func didDismiss() {
        userVM.getAllUsers()
        userVM.getCurrentUser()
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
