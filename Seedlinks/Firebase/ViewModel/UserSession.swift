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
    
//    @Published var email: String = ""
//    @Published var password: String = ""
//
    @Published var registrationDidFail: Bool = false
    @Published var registrationDidSucceed: Bool = false
    @Published var errorString : String = ""
    @Published var showingAlert = false
    @ObservedObject var dbManager = DatabaseManager()
        
    func deleteUser() {
        
        let user = Auth.auth().currentUser

        user?.delete { error in
            
            dump(user)
          if error == nil {
              do {
                  try Auth.auth().signOut()
                 
              } catch _ {
                  print("Error on logging out")
              }
         
          } else {
            print("Failed deleting")
          }
        }
        
    }
    
    func createNewAccount(email: String, password: String, username: String) {
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { [self] result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.errorString = err.localizedDescription
                self.registrationDidFail = true
                return
            }
            let userID = result?.user.uid ?? ""
            print("Successfully created user: \(userID)")
            self.dbManager.addUser(userID: userID, username: username, email: email)
            self.registrationDidSucceed = true
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
        actionCodeSettings.url = URL(string: "https://www.seedlinks-67e57.firebaseapp.com")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            
            if error == nil {
                UserDefaults.standard.set(email, forKey: "Email")
                   print("success")
            } else {
              print("erroreeeeee")
                     return
            }
        }
    }
    
    func authAssigner() {

        Auth.auth().addStateDidChangeListener { auth, user in

            
            if Auth.auth().currentUser != nil {
                if let user = user {

                    self.userAuthenticatedId = user.uid
                    self.isLogged = true
                }
            } else {
                self.isLogged = false
//                self.userAuthenticatedId = ""
            }
            
        }
    
    }
    
    func logOut() {
        
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
           
        } catch _ {
            print("Error on logging out")
        }
        isLogged = false
    }
}


