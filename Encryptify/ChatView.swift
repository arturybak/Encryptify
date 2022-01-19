//
//  ChatView.swift
//  Encryptify
//
//  Created by Artur Rybak on 13/01/2022.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject private var userVM = UserViewModel()

    @State private var showingRegistrationForm = false
    
    @ViewBuilder
    var body: some View {
        NavigationView {
                VStack {
                    if userVM.users.isEmpty {
                        Spacer()
                        Text("First time?")
                            .font(.title2)
                    } else if (userVM.users.count == 1) {
                        Spacer()
                        Text("Welcome \((userVM.currentUser?.name ?? userVM.users[0].name)!)!")
                            .font(.title)
                            .padding(.bottom, 10.0)
                        Spacer()
                        Text("Add your first Contact")
                            .font(.title3)
                            .foregroundColor(.gray)
                    } else {
                        conversationList
                        //Spacer()
                    }
                    Button(action: {showingRegistrationForm.toggle()}) {Text(userVM.users.isEmpty ? "Sign In" : "Add Contact").font(.title).frame(maxWidth: .infinity)}
                    .padding([.leading, .trailing])
                    .buttonStyle(K.GradientButtonStyle())
                }
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: fetchData) {
                    UserRegistrationView(firstUser: userVM.users.isEmpty)
                }
            }
        .onAppear(perform: {fetchData()})
    }
    
    private var conversationList: some View {
        List{
            ForEach(userVM.users.filter {!$0.isCurrentUser}) { user in
                NavigationLink(destination: ConversationView(user: user)) {
                    HStack(spacing: 15) {
                        Image(uiImage: UIImage(data: (user.avatar ?? K.Avatars.defaultAvatar)!)!)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(user.name!)
                                .font(.system(size: 16, weight: .bold))
                            Text("Last Message")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                    }
                }
            }.onDelete(perform: deleteUser)
        }
    }
        
    func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = userVM.users[index + 1] // because of filtering
            userVM.delete(user)
        }
        userVM.getAllUsers()
    }
    
    func fetchData() {
        userVM.getAllUsers()
        userVM.getCurrentUser()
    }
}




struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
