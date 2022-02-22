//
//  UserSession.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 17/02/22.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class FirebaseManager: NSObject {

    let auth: Auth

    public var isLogged: Bool = false
    public var userAuthenticatedId: String = ""
   

    static let shared = FirebaseManager()

    override init() {
        

        self.auth = Auth.auth()

        super.init()
    }
    
   
}

class UserSession: ObservableObject {
    @Published var isLogged: Bool = false
    @Published var userAuthenticatedId: String = ""
    @Published var userAuthUsername = ""
    
    func deleteUser(userID: String) {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if error == nil {
            print("Successful deleting")
          } else {
            print("Failed deleting")
          }
        }
    }
    
    func passwordReset(email: String) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                print("success")
            } else {
                
            }
        }
    }
    
}


