//
//  Message.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import Foundation
import CoreLocation

struct Message: Identifiable {
    
    var id: String
    var userID: String 
    var author: String
    var message: String
    var publicationDate: Date
//    var location: CLLocation
    var dateString: String
    var category: String
    var anonymous: Bool
    var privat: Bool
    
}
