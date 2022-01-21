//
//  MessageShareView.swift
//  Encryptify
//
//  Created by Artur Rybak on 21/01/2022.
//

import SwiftUI

struct MessageShareView: View {
    var message: Message? = nil
    
    var body: some View {
        let msg = Data([UInt8](message!.content!.utf8))
        let secret = try! Secret(data: msg, threshold: K.SecretSharing.threshold, shares: K.SecretSharing.shares)
        let shares = try! secret.split()
                
        //Text()
        VStack {
            Text("share your message with \(message!.user!.name!)!")
                .font(.title)
            Spacer()
            ForEach(shares.indices) { index in
                Button(action: {sharingSheet(share: shares[index].description)}) {Text("part \(index+1)").font(.title)}
                .buttonStyle(K.GradientButtonStyle())
            }
            Spacer()
            Text("Psst! They will need at least \(K.SecretSharing.threshold) parts to recover your message")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                
        }
    }
}

func sharingSheet(share: String) {
    guard let urlShare = URL(string: share) else { return }
    let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    window!.rootViewController?.present(activityVC, animated: true, completion: nil)
}

//struct MessageShareView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageShareView()
//    }
//}
