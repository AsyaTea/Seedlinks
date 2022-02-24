//
//  ViewModel.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import Foundation
import Firebase
import CoreLocation
import SwiftUI
import FirebaseAuth

class DatabaseManager: ObservableObject {
    
    @Published var list = [Message]()
    @Published var userList = [Message]()
    //  @Published var user = User(id: "" ,username: "", email: "")
    @Published var user : User?
    @Published var username: String = "Default"
    @Published var message = Message(id: "", userID: "", author: "", message: "", publicationDate: Date.now, dateString: "", category: "", anonymous: false, privat: false, longitude: "", latitude: "")
    @Published var messageUser = Message(id: "", userID: "", author: "", message: "", publicationDate: Date.now, dateString: "", category: "", anonymous: false, privat: false, longitude: "", latitude: "")
    
    
    @Published var errorMessage = ""
    
    let db = Firestore.firestore()              // Reference to the database
    
    init() {
        fetchCurrentUser()
    }
    
    func getData() {
        
        
        db.collection("messages").getDocuments { snapshot, error in  // Read document at a specific path
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {  // Update list property in the main thread
                        
                        self.list = snapshot.documents.map { d in
                            
                            return Message(id: d.documentID,
                                           userID: d["userID"] as? String ?? "",
                                           author: d["author"] as? String ?? "",
                                           message: d["message"] as? String ?? "",
                                           publicationDate: d["publicationDate"] as? Date ?? Date.init(),
                                           dateString: d["dateString"] as? String ?? "",
                                           category: d["category"] as? String ?? "",
                                           anonymous: d["anonymous"] as? Bool ?? Bool.init(),
                                           privat: d["private"] as? Bool ?? Bool.init(),
                                           longitude: d["longitude"] as? String ?? "",
                                           latitude: d["latitude"] as? String ?? "",
                                           reportCount: d["reportCount"] as? Int ?? 0)

                        }
                    }
                    
                }
            } else {
                
                //Handle errors
                
            }
        }
    }
   
    
    func userMessagesQuery(userID: String) {
        db.collection("messages").whereField("userID", isEqualTo: userID)
            .getDocuments { querySnapshot, error in
                
                if error == nil {
                    
                    DispatchQueue.main.async {
                        
                        self.userList = [Message]()
                        
                        for d in querySnapshot!.documents {
                            
                            print("\(d)")
                            self.userList.append(
                                Message(id: d.documentID,
                                userID: d["userID"] as? String ?? "",
                                author: d["author"] as? String ?? "",
                                message: d["message"] as? String ?? "",
                                publicationDate: d["publicationDate"] as? Date ?? Date.init(),
                                dateString: d["dateString"] as? String ?? "",
                                category: d["category"] as? String ?? "",
                                anonymous: d["anonymous"] as? Bool ?? Bool.init(),
                                privat: d["private"] as? Bool ?? Bool.init(),
                                longitude: d["longitude"] as? String ?? "",
                                latitude: d["latitude"] as? String ?? "",
                                reportCount: d["reportCount"] as? Int ?? 0)
                                    
                            )
                        }
//                        self.userList.so
                        
                       
                    }
                }
            }
    }
    
    func addMessage(userID: String, author: String, message: String, publicationDate: Date, dateString: String, category: String, anonymous: Bool, privat: Bool, latitude : String, longitude : String) {
        
        
        
        db.collection("messages").addDocument(data: ["userID": userID , "author": author, "message": message, "publicationDate": publicationDate, "dateString": dateString, "category": category, "anonymous": anonymous, "private": privat, "latitude" : latitude,"longitude" :longitude, "reportCount" : 0]) { error in
            
            if error == nil {
                
                self.getData()
                
            } else {
                //Handle errors
            }
        }
        
    }
    
    func deleteMessage(_ messageId: String) {
      
        db.collection("messages").document(messageId).delete { error in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    self.list.removeAll { message in
                        
                        return message.id == messageId
                    }
                }
            } else {
                // Handle errors
            }
        }
    }
    
    func deleteAllUserMessages(userID : String) {
        
        db.collection("messages").whereField("userID", isEqualTo: userID)
            .getDocuments { querySnapshot, error in
                
                if error == nil {
                    
                    DispatchQueue.main.async {
                       
                        for _ in querySnapshot!.documents {
                            
                            self.db.collection("messages").document().delete() { error in
                                if error == nil {
                                    
                                } else {
                                    //errors diocannn
                                }
                                
                            }
                           
                        }
                    }
                }
            }
        
    }
    
    func addUser(userID: String, username: String, email: String) {
        db.collection("user").addDocument(data: ["userID": userID, "username": username, "email": email]) { error in
            
            if error == nil {
                self.getData()
                
            } else {
                //Handle errors
            }
        }
    }
    
    func deleteUserDatabase(userID: String) {
        db.collection("user").document(userID).delete() { error in
            
            if error == nil {
                print("User deleted on Database!")
            } else {
                print("Something went wrong!")
            }
        }
    }
    
 
    
    func getUsername(userID: String)  {
        
        db.collection("user").whereField("userID", isEqualTo: userID) .getDocuments { querySnapshot, error in
            
            if error == nil {
                
                self.username = (querySnapshot?.documents[0]["username"] as? String ?? "")
                
            }
        }
    }
    
private func fetchCurrentUser() {
    guard let id = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        db.collection("user").document(id).getDocument { querySnapshot, error in
            
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            guard let data = querySnapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
            let id = data["userID"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            
            self.user = User(id: id,username: username, email: email)
            print("ODIO LA MIA VITA")
        }
    }
    
    func getMessageIDquery(messageID: String)  {

        for i in self.list {
            if i.id == messageID {
                print(message)
               return message = i
               
            } else {
               print("è andato male")
            }
        }
    }
    
    func getMessageIdUserQuery(messageID: String)  {

        for i in self.userList {
            if i.id == messageID {
                print(messageUser)
                return messageUser = i
               
            } else {
               print("è andato male")
            }
        }
    }
    
    func getRadiusMessagesQuery() {  //Takes user position and returns every message in a certain radius
        
    }
    
    func formatting(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
   
}
        




