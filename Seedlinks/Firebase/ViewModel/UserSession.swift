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
       
    
    init() {
        
        authAssigner()
    }
    
    
    let db = Firestore.firestore()
    
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
    
    func sendSignInEmail(email: String) {
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            
            if error == nil {
                UserDefaults.standard.set(email, forKey: "Email")
                   print("success")
            } else {
              print("error")
                     return
            }
        }
    }
    
    func authAssigner() {

        Auth.auth().addStateDidChangeListener { auth, user in

            if let user = user {

                self.userAuthenticatedId = user.uid
                self.isLogged = true
        }
    }
    
}
}


