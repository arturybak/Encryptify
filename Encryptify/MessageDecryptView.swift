//
//  MessageDecryptView.swift
//  Encryptify
//
//  Created by Artur Rybak on 27/01/2022.
//

import SwiftUI

struct MessageDecryptView: View {
    var input: URL
    var components: URLComponents
    var share: String?
    var sentOn: String?
    
    @ObservedObject private var userVM = UserViewModel()
    @ObservedObject private var messageVM = MessageViewModel()
    @Environment (\.presentationMode) var presentationMode

    
    init(url: URL) {
        input = url
        components = URLComponents(
            url: input,
            resolvingAgainstBaseURL: false
        )!
        share = getQueryStringParameter(url: components, param: "share")!
        sentOn = getQueryStringParameter(url: components, param: "date")!
    }
    
    
    var body: some View {
        NavigationView {
            VStack() {
                Text("Which conversation?")
                    .font(.title)
                ContentMessageView(contentMessage: share!, isCurrentUser: false)
                HStack {
                    Text(getDateFromString(sentOn!)!, style: .date)
                    Text(getDateFromString(sentOn!)!, style: .time)
                }.foregroundColor(Color.gray)
                List{
                    ForEach(userVM.users) { user in
                            Button(action: {
                                saveShare(user: user)
                            }, label: {
                                HStack(spacing: 15) {
                                    Image(uiImage: UIImage(data: (user.avatar ?? K.Avatars.defaultAvatar)!)!)
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())

                                    VStack(alignment: .leading) {
                                        Text(user.name ?? "no users")
                                            .font(.headline)
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                            })
                            .padding([.leading, .trailing])
                            .buttonStyle(K.GradientButtonStyle())
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
            }
            .onAppear(perform: {fetchData()})
            .navigationTitle(Text("Share Message"))
        }
    }
    
    private func saveShare(user: User) {
        messageVM.content = share!
        messageVM.user = user
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd.hh:mm:ssz"
        let date = df.date(from: sentOn!)!
        messageVM.save(isSender: false, date: date)
        messageVM.getConversation(with: user.id!)
        presentationMode.wrappedValue.dismiss()
    }

    func fetchData() {
        userVM.getAllUsers()
        userVM.getCurrentUser()
    }

    func getDateFromString(_ dateAsString: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd.hh:mm:ssz"
        return df.date(from: dateAsString)
    }
    
    func getQueryStringParameter(url: URLComponents, param: String) -> String? {
        url.queryItems?.first(where: { $0.name == param })?.value
    }
}

struct MessageDecryptView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDecryptView(url: URL(string: "encryptify://message?share=1-477850e373e437&date=2022-01-27.09:12:55GMT")!)
    }
}
