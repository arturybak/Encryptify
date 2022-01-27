//
//  EncryptifyApp.swift
//  Encryptify
//
//  Created by Artur Rybak on 24/11/2021.
//

import SwiftUI

@main
struct EncryptifyApp: App {
    @State private var acceptedURL: IdentifiableURL?
    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .onOpenURL { url in
                    acceptedURL = .init(id: .init(), url: url)
//                    print("accepted \(acceptedURL!.url.absoluteString))")
                }
                .sheet(item: $acceptedURL) { link in
                    MessageDecryptView(url: link.url)
                }
        }
    }
}

struct IdentifiableURL: Identifiable {
    public var id: UUID
    public var url: URL
}
