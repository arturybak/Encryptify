//
//  Constants.swift
//  Encryptify
//
//  Created by Artur Rybak on 14/01/2022.
//

//import UIKit
import SwiftUI

struct K {
    struct Avatars {
        static let defaultAvatar = UIImage(named: "default")!.jpegData(compressionQuality: 1.0)
    }
    
    struct Colors {
        static let gradient = LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing)
    }
}
