//
//  ChatView.swift
//  Encryptify
//
//  Created by Artur Rybak on 13/01/2022.
//

import SwiftUI

struct ChatView: View {
    @State private var showingRegistrationForm = false
    var body: some View {
        NavigationView {
            VStack {
                Text("First time?")
                    .font(.title)
                    .padding(.bottom, 10.0)
                Button(action: {showingRegistrationForm.toggle()}) {Text("Sign In").font(.title)}
                .buttonStyle(GradientButtonStyle())
            }
            .navigationBarTitle(Text("Encryptify"), displayMode: .automatic)
            .sheet(isPresented: $showingRegistrationForm) {
                UserRegistrationView()
            }

        }
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
