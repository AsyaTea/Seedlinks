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
    
//    @ObservedObject var dbManager : DatabaseManager
    var body: some View {
        ForEach(dbManager.userList, id: \.self) { item in
            MessageView(messageId: item.id, messageText: item.message, messageAuthor: item.author, pubblicationDate: item.publicationDate, dateString: item.dateString, category: item.category, anonymous: item.anonymous,dbManager: dbManager, userSession: userSession)
                
        }
        .onAppear{
            dbManager.userMessagesQuery(userID: userSession.userAuthenticatedId)
        }
        //chiamare la funzione nella main view e passare il parametro
           
    }
 }
   


//struct MessageList_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageListView()
//    }
//}
