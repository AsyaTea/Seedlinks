//
//  MessageView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
import CoreLocation

let actionTriggered: String = "Action 1 triggered"
let delDatabase: String = "Deleting from database"

struct ContentLengthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
    
}

struct MessageView: View {
    
    let messageId: String
    var messageText : String
    let messageAuthor: String
    let pubblicationDate : Date
    let dateString: String
    var category: String
    var anonymous: Bool
    var privat: Bool
    let longitude: String
    let latitude: String
    let locationName : String
    @State var textHeight: CGFloat = 0
    
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var userSession : UserSession
    
    @State var navigateToMap = false
    
    
    func getRadius1(bLat : Double, bLong: Double) -> Double {
        let myCoord1 = CLLocation(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0.0,longitude: locationManager.lastLocation?.coordinate.longitude ?? 0.0)
        let genericCoord1 = CLLocation(latitude: bLat, longitude: bLong)
        let distanceInMeters1 = myCoord1.distance(from: genericCoord1)
        // print("DISTANZA IN METRI" ,distanceInMeters1)
        return distanceInMeters1
    }
    
    var body: some View {
        ZStack{
            if (getRadius1(bLat: Double(latitude) ?? 0.0 , bLong: Double(longitude) ?? 0.0 ) <= 300.0){
                
                RectangleInRadius(messageId: messageId, messageText: messageText, messageAuthor: messageAuthor, pubblicationDate: pubblicationDate, dateString: dateString, category: category, anonymous: anonymous, privat: privat, longitude: longitude, latitude: latitude, locationName: locationName)
                
            }
            else {
                RectangleNotInRadius(messageId: messageId, messageText: messageText, messageAuthor: messageAuthor, pubblicationDate: pubblicationDate, dateString: dateString, category: category, anonymous: anonymous, privat: privat, longitude: longitude, latitude: latitude, locationName: locationName)
            }
        }
        .contextMenu
        {
            Button(action: {
                
                dbManager.getMessageIdUserQuery(messageID: messageId)
                locationManager.setRegion(latitude: Double(dbManager.messageUser.latitude) ?? 0.0, longitude: Double(dbManager.messageUser.longitude) ?? 0.0)
                print(dbManager.messageUser.latitude,dbManager.messageUser.longitude)
                self.navigateToMap = true
                
                print(NSLocalizedString(actionTriggered, comment: ""))
                
            }
                   , label:
                    {
                
                HStack{
                    
                    Text("View on map")
                    Image(systemName: "map")
                }
            })
            
            Button(role: .destructive ,action: {
                print(NSLocalizedString(delDatabase, comment: ""))
                dbManager.deleteMessage(messageId)
            }, label:
                    {
                HStack{
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }).disabled(getRadius1(bLat: Double(latitude) ?? 0.0 , bLong: Double(longitude) ?? 0.0 ) >= 300.0)
            
        }
        NavigationLink(destination: MapView(locationManager: locationManager,dbManager: dbManager, userSession:userSession),isActive: $navigateToMap){
        }
    }
    
}


//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(message: Message?, messageText: "PROVA", messageAuthor: "PROVA", pubblicationDate: Date.now, dateString: "MOBASTA", category: "message", anonymous: true)
//    }
//}
