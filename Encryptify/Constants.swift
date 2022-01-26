//
//  Constants.swift
//  Encryptify
//
//  Created by Artur Rybak on 14/01/2022.
//

//import UIKit
import SwiftUI

struct K {
    
    struct GradientButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .foregroundColor(Color.white)
                .padding(15)
                .background(K.Colors.gradient)
                .cornerRadius(15.0)
                .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
        }
    }

    struct SecretSharing {
        static let threshold = 2
        static let shares = 3
    }
    struct Avatars {
        static let defaultAvatar = UIImage(named: "default")!.jpegData(compressionQuality: 1.0)
    }
    
    struct Colors {
        static let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo]), startPoint: .leading, endPoint: .trailing)
    }
}
