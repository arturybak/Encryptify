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
                .onAppear(perform: {fetchData()})
                .navigationTitle(Text("Encryptify"))
                .sheet(isPresented: $showingRegistrationForm, onDismiss: fetchData) {
                    UserRegistrationView(firstUser: userVM.users.isEmpty)
                }
            }
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
                            HStack {
                                Text(user.name ?? "no users")
                                    .font(.headline)
                                Spacer()
                                Text((user.lastMessage != nil) ? timeAgo(since: user.lastMessage!.date!) : "")
                                    .font(.callout)
                                    .foregroundColor(Color(.lightGray))
                            }
                            Text((user.lastMessage != nil) ? user.lastMessage!.content! : "Start the conversation!")
                                .frame(width: 190, alignment: .leading)
                                .lineLimit(1)
                                .font(.callout)
                                .foregroundColor(Color(.gray))
                        }
                        //Spacer()
                        
                    }
                }
            }.onDelete(perform: deleteUser)
        }
    }
    
    func timeAgo(since: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowsFractionalUnits = false
        //formatter.collapseLargestUnit = true
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.second, .minute, .hour, .day, .month, .year]

        return formatter.string(from: since, to: Date())!
    }
        
    func deleteUser(at offsets: IndexSet) {
        offsets.forEach { index in
            let user = userVM.users[index + 1] // because of filtering
            print("attempting deletion of \(user.name!)")
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
