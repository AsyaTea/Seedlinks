//
//  Message.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import Foundation
import CoreLocation

struct Message: Identifiable,Hashable {

    var id: String
    var userID: String 
    var author: String
    var message: String
    var publicationDate: Date
    var dateString: String
    var category: String
    var anonymous: Bool
    var privat: Bool
    var longitude : String
    var latitude : String
    var coordinate: CLLocationCoordinate2D{CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)}
    var reportCount: Int
    
}
