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
            MessageView(messageText: item.message, messageAuthor: item.author,pubblicationDate: item.publicationDate)
        }.onAppear{
            dbManager.getData()
        }
    }
}

struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
