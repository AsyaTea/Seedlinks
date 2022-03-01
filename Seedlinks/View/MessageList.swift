//
//  MessageList.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 15/02/22.
//

import SwiftUI

struct MessageListView: View {
    @ObservedObject var userSession : UserSession
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var locationManager : LocationManager
    
    //    @ObservedObject var dbManager : DatabaseManager
    var body: some View {
        ForEach(dbManager.userList, id: \.self) { item in
            MessageView(messageId: item.id, messageText: item.message, messageAuthor: item.author, pubblicationDate: item.publicationDate, dateString: item.dateString, category: item.category, anonymous: item.anonymous,longitude: item.longitude, latitude: item.latitude,dbManager: dbManager, locationManager: locationManager, userSession: userSession)
                .padding(.top,2)
            
        }
        .onAppear{
            dbManager.userMessagesQuery(userID: userSession.userAuthenticatedId)
//            orderByDistance()
        }
        //chiamare la funzione nella main view e passare il parametro
    }
    func orderByDistance()  {

        for var message in dbManager.userList {
            let longitude = Double(message.longitude)
            let latitude = Double(message.latitude)
            let distanceFromPos = locationManager.getRadius(bLat: latitude ?? 0.0, bLong: longitude ?? 0.0)
            message.distanceFromPos = distanceFromPos
        }
        dbManager.userList.sort {
            $0.distanceFromPos ?? 0.0 < $1.distanceFromPos ?? 0.0
        }

    }
}



//struct MessageList_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageListView()
//    }
//}
