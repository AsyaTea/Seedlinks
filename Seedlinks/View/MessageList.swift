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
                MessageView(messageId: item.id, messageText: item.message, messageAuthor: item.author, pubblicationDate: item.publicationDate, dateString: item.dateString, category: item.category, anonymous: item.anonymous, privat: item.privat,longitude: item.longitude, latitude: item.latitude,locationName: item.locationName,dbManager: dbManager, locationManager: locationManager, userSession: userSession)
                    .padding(.top,5.5)
            }
            .onDelete(perform: delete)
            .swipeActions(edge: .trailing){
                Button {
                    print("Delete")
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
            .onAppear{
                dbManager.userMessagesQuery(userID: userSession.userAuthenticatedId)
                orderByDistance()
            }
    }
    func delete(at offsets: IndexSet) {
        dbManager.userList.remove(atOffsets: offsets)
    }
    func orderByDistance()  {

        for var message in dbManager.userList {
            let longitude = Double(message.longitude)
            let latitude = Double(message.latitude)
            let distanceFromPos = locationManager.getRadius(bLat: latitude ?? 0.0, bLong: longitude ?? 0.0)
            message.distanceFromPos = distanceFromPos
            print("Distance from positions is\(message.distanceFromPos ?? 0.0)")
            
        }
        
//        for i in 0...dbManager.userList.count {
//            
//        }
        dbManager.userList.sort {
            $0.distanceFromPos ?? 0.0 < $1.distanceFromPos ?? 0.0
        }
        print(dbManager.userList)
    }
}



//struct MessageList_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageListView()
//    }
//}
