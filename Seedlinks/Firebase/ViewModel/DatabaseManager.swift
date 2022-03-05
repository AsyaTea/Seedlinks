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

var localizeAnonymous: String = "Anonymous"
class DatabaseManager: ObservableObject {
    
    @Published var list = [Message]()
    @Published var userList = [Message]()
    //  @Published var user = User(id: "" ,username: "", email: "")
    @Published var user : User?
    @Published var username: String = "Default"
    @Published var message = Message(id: "", userID: "", author: "", message: "", publicationDate: Date.now, dateString: "", category: "", anonymous: false, privat: false, longitude: "", latitude: "",  reportCount: 0, locationName: "")
    @Published var messageUser = Message(id: "", userID: "", author: "", message: "", publicationDate: Date.now, dateString: "", category: "", anonymous: false, privat: false, longitude: "", latitude: "",  reportCount: 0, locationName: "")
    @Published var userDocumentID = ""
    @Published var errorMessage = ""
    @Published var selectedCategory = "Date"
    @Published var filtering = ["Date","Distance"]
    
    let db = Firestore.firestore()              // Reference to the database
    
    init() {
//        fetchCurrentUser()
    }
    
    enum ErrorHandler{
        
    }
    
    func getData() {
        
        db.collection("messages").whereField("private", isEqualTo: false)
            .getDocuments { querySnapshot, error in
                
                if error == nil {
                    
                    self.list = [Message]()
                        for d in querySnapshot!.documents {
                            
                            
//                            print("\(d)")
                            self.list.append(
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
                                reportCount: d["reportCount"] as? Int ?? 0,
                                locationName: d["location"] as? String ?? "")
                    
                            )
                        }
                } else {
                    //Handle errors
                }
            }
        
    }
   
    
    func userMessagesQuery(userID: String) {
        db.collection("messages").whereField("userID", isEqualTo: userID).order(by: "publicationDate", descending: true)
            .getDocuments { querySnapshot, error in
                
                if error == nil {
                    
                    DispatchQueue.main.async {
                        
                        self.userList = [Message]()
                        
                        for d in querySnapshot!.documents {
                            
                           
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
                                reportCount: d["reportCount"] as? Int ?? 0,
                                locationName: d["location"] as? String ?? "")
                                    
                            )
                        }
//                        self.userList.sort {
//                            $0.publicationDate > $1.publicationDate
//                        }
                        print(self.userList)
                     
                    }
                } else {
                    print("error")
                }
            }
    }
    

    
    func addMessage(userID: String, author: String, message: String, publicationDate: Date, dateString: String, category: String, anonymous: Bool, privat: Bool, latitude : String, longitude : String, reportCount: Int, locationName : String) {
        
        var name = author
        
        if anonymous {
            name = NSLocalizedString(localizeAnonymous, comment: "")
        } 
        
        db.collection("messages").addDocument(data: ["userID": userID , "author": name, "message": message, "publicationDate": publicationDate, "dateString": dateString, "category": category, "anonymous": anonymous, "private": privat, "latitude" : latitude,"longitude" :longitude, "reportCount" : 0,"location": locationName]) { error in
            
            if error == nil {
                
                self.getData()
                
            } else {
                print("error")
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
//                print(error)
            }
        }
    }
    
    func deleteAllUserMessages(userID : String) {
                
        db.collection("messages").whereField("userID", isEqualTo: userID)
            .getDocuments { querySnapshot, error in
                
                
                if error == nil {
                                                        
                        for d in querySnapshot!.documents {
                                                        
                            self.db.collection("messages").document(d.documentID).delete() { error in
                                if error == nil {
                                    print("Success on deleting user messages")
                                    
                                } else {
                                    print("error")
                                }

                            }
                        }
                    
                } else {
                    //error handle
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
                self.userDocumentID = (querySnapshot?.documents[0].documentID ?? "")
            } else {
                //errors
            }
        }
    }
    

    
    func getMessageIDquery(messageID: String)  {

        for i in self.list {
            if i.id == messageID {
                print(message)
               return message = i
               
            } else {
               
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
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func reportedMessage(messageID: String) {
        
        let reportedMessage = db.collection("messages").document(messageID)
       
            if self.message.reportCount >= 5 {
                
                reportedMessage.addSnapshotListener { documentSnapshot, error in
                    if error == nil {
                        
                        DispatchQueue.main.async {
                            if let document = documentSnapshot?.data() {
                                
                                self.db.collection("reportedMessages").addDocument(data: document) { error in
                                    
                                    if error == nil {
                                        print("success on spostare collection")
                                        self.getData()
                                        
                                    } else {
                                        print("error")
                                    }
                                }
                            }
                        }
                        
                    } else {
                        //
                    }
                }
                reportedMessage.delete()
                
            } else {
                                
                reportedMessage.updateData(["reportCount": message.reportCount])  { error in
                    
                    if error == nil {
                        print("Successfully increased")
                        
                    } else {
                        print("Didn't increase report count")
                    }
                }
            }
    }
}
        




