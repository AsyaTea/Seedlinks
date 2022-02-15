//
//  User.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 15/02/22.
//

import Foundation
import Foundation
import CoreLocation

struct User: Identifiable {
    
    var id = UUID()
    var username: String
    var name: String
    var surname: String
    var location: CLLocation
    var email: String

    
}
