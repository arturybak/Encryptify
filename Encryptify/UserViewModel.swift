//
//  UserViewModel.swift
//  Encryptify
//
//  Created by Artur Rybak on 13/01/2022.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class UserViewModel: ObservableObject {

    //@Environment(\.managedObjectContext) private var viewContext

    var image: UIImage? = nil
    var name: String = ""
    
    func save(isSigningIn: Bool = false) {
        let pickedAvatar = image!.jpegData(compressionQuality: 1.0)
        let user = User(context: PersistenceController.shared.viewContext)
        user.name = name
        user.isCurrentUser = isSigningIn
        user.avatar = pickedAvatar
        user.id = UUID()
        
        PersistenceController.shared.save()
    }
}
