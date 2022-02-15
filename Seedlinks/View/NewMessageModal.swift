//
//  NewMessageView.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import SwiftUI

struct NewMessageView: View {
    @State var showSheetView = false
        
        var body: some View {
            Button(action: {
                self.showSheetView.toggle()
            }) {
                Text("Show Sheet View")
            }.sheet(isPresented: $showSheetView) {
                SheetView(showSheetView: self.$showSheetView)
            }
        }
}
struct SheetView: View {
    
    @State var message = "" 
    @Binding var showSheetView: Bool
    @State private var selectedCategory = "Message"
    @State private var anonymous = false
    @State private var privat = false
    var categories = ["Message", "Advice"]
    
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
                    print("Dismissing sheet view...")
                    self.showSheetView = false
                }) {
                    HStack {
                        Text("<")
                            .font(.custom("Times New Roman", size: 18))
                            .fontWeight(.bold)
                        Text("Profile")
                    }
                })
                .navigationBarTitle(Text("New seed"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    print("Dismissing sheet view...")
                    self.showSheetView = false
                }) {
                    Text("Plant")
                })
            
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}


