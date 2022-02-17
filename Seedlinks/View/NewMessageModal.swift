//
//  NewMessageView.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import SwiftUI

//struct NewMessageView: View {
//    @State var showSheetView = false
//
//        var body: some View {
//            Button(action: {
//                self.showSheetView.toggle()
//            }) {
//                Text("Show Sheet View")
//            }.sheet(isPresented: $showSheetView) {
//                SheetView(showSheetView: self.$showSheetView)
//            }
//        }
//}
struct SheetView: View {
    
    @ObservedObject var userSession: UserSession
    @State var message = "" 
    @Binding var showSheetView: Bool
    @State private var selectedCategory = ""
    @State private var anonymous = false
    @State private var privat = false
 
    var categories = ["Message", "Advice"]
    @ObservedObject var dbManager : DatabaseManager
    
    var body: some View {
        NavigationView {
                VStack {
                    Divider()
                    TextField("Write a text", text: $message)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 400, height: 300, alignment: .topLeading)
                    List {
                        Toggle("Anonymous", isOn: $anonymous)
                        Toggle("Private", isOn: $privat)
                        Picker("Choose a category", selection: $selectedCategory) {
                                        ForEach(categories, id: \.self) {
                                            Text($0)
                                        }
                        }.pickerStyle(.inline)
                        
//
                    }
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                }
                .navigationBarItems(leading: Button(action: {
                    self.showSheetView = false
                }) {
                    HStack {
                        Text("<")
                            .font(.custom("Times New Roman", size: 18))
                            .fontWeight(.bold)
                        Text("Garden")
                    }
                })
                .navigationBarTitle(Text("New seed"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showSheetView = false
                    dbManager.addMessage(userID: userSession.userAuthenticatedId, author: "Anonymous", message: message, publicationDate: Date.now, dateString: DatabaseManager().formatting(date: Date.now), category: selectedCategory.lowercased(), anonymous: anonymous, privat: privat)
//                    database.userMessagesQuery()

                }) {
                    Text("Plant")
                }.disabled(self.message.isEmpty || self.selectedCategory.isEmpty)
                )
            
        }
    }
}

//struct NewMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMessageView()
//    }
//}


