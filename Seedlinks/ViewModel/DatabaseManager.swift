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
    
    func getData() {
        
        let db = Firestore.firestore()  // Reference to the database
        
        db.collection("messages").getDocuments { snapshot, error in  // Read document at a specific path
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {  // Update list property in the main thread
                        
                        self.list = snapshot.documents.map { d in
                            
                            return Message(id: d.documentID,
                                           author: d["author"] as? String ?? "",
                                           message: d["message"] as? String ?? "",
                                           publicationDate: d["publicationDate"] as? Date ?? Date.init())
                            //                                           location: d["location"] as? CLLocation ?? CLLocation.init(),
                            //                                           category: "Advice",
                            //                                           anonymous: true,
                            //                                           privato: true)
                            
                            
                        }
                    }
                    
                }
            } else {
                
                //Handle errors
                
            }
        }
    }
    
    func addMessage(author: String, message: String, publicationDate: Date) {
        
        let db = Firestore.firestore()
        
        db.collection("messages").addDocument(data: ["author": author, "message": message, "publicationDate": publicationDate]) { error in
            
            if error == nil {
                
                self.getData()
                
            }
        }
        
    }
    
//    func getDateOnly(fromTimeStamp timestamp: TimeInterval) -> String {
//        let dayTimePeriodFormatter = DateFormatter()
//        dayTimePeriodFormatter.timeZone = TimeZone.current
//        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
//        return dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: timestamp))
//        
//    }
}

