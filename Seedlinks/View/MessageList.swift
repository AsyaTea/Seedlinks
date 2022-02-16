//
//  MessageList.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 15/02/22.
//

import SwiftUI

struct MessageListView: View {
    @StateObject var dbManager = DatabaseManager()
    var body: some View {
        ForEach(dbManager.list) { item in
            MessageView(messageId: item.id, messageText: item.message, messageAuthor: item.author, pubblicationDate: item.publicationDate, dateString: item.dateString, category: item.category, anonymous: item.anonymous)
        }.onAppear{
            dbManager.getData()
        }
        //chiamare la funzione nella main view e passare il parametro
        
    }
}

struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
