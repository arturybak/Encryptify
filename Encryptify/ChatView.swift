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
                    .buttonStyle(K.GradientButtonStyle())

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
                    .buttonStyle(K.GradientButtonStyle())
                }
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: didDismiss) {
                    UserRegistrationView()
                }

            } else {
                VStack {
                    List{
                        ForEach(userVM.users.filter {!$0.isCurrentUser}) { user in
                            NavigationLink(destination: ConversationView(user: user)) {
                                HStack(spacing: 15) {
                                    Image(uiImage: UIImage(data: (user.avatar ?? K.Avatars.defaultAvatar)!)!)
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        //.cornerRadius(20)
                                        .clipShape(Circle())

                                    VStack(alignment: .leading) {
                                        Text(user.name!)
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Last Message")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                    }                                }
                            }
                        }.onDelete(perform: deleteUser)
                    }
                    Spacer()
                    Button(action: {showingRegistrationForm.toggle()}) {Text("Add Contact").font(.title).frame(maxWidth: .infinity)}
                    .padding([.top, .leading, .trailing])
                    .buttonStyle(K.GradientButtonStyle())

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





struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
