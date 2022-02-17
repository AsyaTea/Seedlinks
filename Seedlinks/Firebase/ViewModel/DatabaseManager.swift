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

class DatabaseManager: ObservableObject {
    
    
    @Published var list = [Message]()
    @Published var userList = [Message]()
    @Published var user = User(id: "" ,username: "", email: "")
    @Published var username: String = ""
    @StateObject var userSession  = UserSession()
    
    let db = Firestore.firestore()              // Reference to the database
    
    func formatting(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
                                           //             location: d["location"] as? CLLocation ?? CLLocation.init(),
                                           category: d["category"] as? String ?? "",
                                           anonymous: d["anonymous"] as? Bool ?? Bool.init(),
                                           privat: d["private"] as? Bool ?? Bool.init(),
                                            longitude: d["longitude"] as? String ?? "",
                                            latitude: d["latitude"] as? String ?? "" )
                            
                            
                            
                            
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
                    for d in querySnapshot!.documents {
                        
                        print("\(d)")
                        self.userList.append(Message(id: d.documentID,
                                                     userID: d["userID"] as? String ?? "",
                                                     author: d["author"] as? String ?? "",
                                                     message: d["message"] as? String ?? "",
                                                     publicationDate: d["publicationDate"] as? Date ?? Date.init(),
                                                     dateString: d["dateString"] as? String ?? "",
                                                     
                                                     category: d["category"] as? String ?? "",
                                                     anonymous: d["anonymous"] as? Bool ?? Bool.init(),
                                                     privat: d["private"] as? Bool ?? Bool.init(),
                                             longitude: d["longitude"] as? String ?? "",
                                             latitude: d["latitude"] as? String ?? ""))
                        
                    }
                }
            }
    }
    
    func addMessage(userID: String, author: String, message: String, publicationDate: Date, dateString: String, category: String, anonymous: Bool, privat: Bool, latitude : String, longitude : String) {
        
        
        
        db.collection("messages").addDocument(data: ["userID": userID , "author": author, "message": message, "publicationDate": publicationDate, "dateString": dateString, "category": category, "anonymous": anonymous, "private": privat, "latitude" : latitude,"longitude" :longitude]) { error in
            
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
    
    func addUser(userID: String, username: String, email: String) {
        db.collection("user").addDocument(data: ["userID": userID, "username": username, email: email]) { error in
            
            if error == nil {
                self.getData()
                
            } else {
                //Handle errors
            }
        }
    }
    
    //    func getUsername(userID: String)  {
    //
    //        db.collection("user").whereField("userID", isEqualTo: userID) .getDocuments { querySnapshot, error in
    //
    //            if error == nil {
    //                for d in querySnapshot!.documents {
    //
    //
    //                    print(User(id: userID,
    //                                username: ["username"] as? String ?? "",
    //                                email: ["email"] as? String ?? ""))
    //                }
    //
    //            }
    //        }
    //    }
    
    
    
}





