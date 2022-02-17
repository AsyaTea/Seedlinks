//
//  ViewModel.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import Foundation
import Firebase
import CoreLocation

class DatabaseManager: ObservableObject {
    
    @Published var list = [Message]()
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
                                           privat: d["private"] as? Bool ?? Bool.init())
                            
                            
                        }
                    }
                    
                }
            } else {
                
                //Handle errors
                
            }
        }
    }
    
//    func userMessagesQuery() {
//        db.collection("messages").whereField("userID", isEqualTo: "S4KDQck3S6irvOWLN6g2")
//            .getDocuments { querySnapshot, error in
//
//                if error == nil {
//                    for d in querySnapshot!.documents {
//
//                        print("\(d)")
//
//                    }
//                }
//            }
//    }
    
    func addMessage(userID: String, author: String, message: String, publicationDate: Date, dateString: String, category: String, anonymous: Bool, privat: Bool) {
        
     
        
        db.collection("messages").addDocument(data: ["userID": "S4KDQck3S6irvOWLN6g2" , "author": author, "message": message, "publicationDate": publicationDate, "dateString": dateString, "category": category, "anonymous": anonymous, "private": privat]) { error in
            
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
    
//    func registerUser(_ username: String,_ email: String, _ password: String) {
//
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//
//            if error == nil {
//
//            } else {
//
//            }
//        }
//    }
    
    
}




