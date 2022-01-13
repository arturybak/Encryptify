//
//  UserViewModel.swift
//  Encryptify
//
//  Created by Artur Rybak on 13/01/2022.
//

import Foundation
import CoreData
import UIKit

class UserViewModel: ObservableObject {
    
    var avatar: UIImage? = nil
    var name: String = ""
    
    func save() {
        
        let user = User(context: PersistenceController.shared.viewContext)
        user.name = name
        
    }
    
}
