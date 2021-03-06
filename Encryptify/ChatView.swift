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
                        let _ = print("displaying chat, users empty")
                        if userVM.currentUser == nil {
                            Spacer()
                            Text("First time?")
                                .font(.title2)
                        } else {
                            Spacer()
                            Text("Welcome \((userVM.currentUser?.name ?? userVM.users[0].name)!)!")
                                .font(.title)
                                .padding(.bottom, 10.0)
                            Spacer()
                            Text("Add your first Contact")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    } else {
                        let _ = print("displaying list of users:")
                        conversationList
                        //Spacer()
                    }
                    Button(action: {showingRegistrationForm.toggle()}) {Text(userVM.currentUser == nil ? "Sign In" : "Add Contact").font(.title).frame(maxWidth: .infinity)}
                    .padding([.leading, .trailing])
                    .buttonStyle(K.GradientButtonStyle())
                }
                .onAppear(perform: {fetchData()})
                .navigationTitle(Text("Encryptify"))
                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading){
//                        Text("Encryptify")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            //print("Button pressed")
                            testSSS()
                        }, label: {
                            Image(systemName: "gear.circle.fill")
                                .font(.title)
                        })
                    }
                }
                .sheet(isPresented: $showingRegistrationForm, onDismiss: fetchData) {
                    UserRegistrationView(firstUser: userVM.currentUser == nil)
                }
            }
    }
    
    private var conversationList: some View {
        List{
            ForEach(userVM.users) { user in
                let _ = print("displaying \(user.name ?? "noname")")
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
    
    private func testSSS() {
        let share1 = "1-38649008064e1b7ed34beb02a90adab4bf88aabf"
        let share2 = "2-a86785adafff56000cf6518ffda91e13f9a4daf9"
        let share3 = "3-d8667fcec8906d2ab09dcef438c8ab8732490332"

        let sharesStings = [share1, share2, share3]
        let sharesObjects = sharesStings.compactMap { try? Secret.Share(string: $0) }
        let someShares = [Secret.Share](sharesObjects)

        let secretData = try!  Secret.combine(shares: someShares)
        let secret = String(data: secretData, encoding: .utf8)
        print("decode is: \(secret ?? "not working")")
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
            let user = userVM.users[index]
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
