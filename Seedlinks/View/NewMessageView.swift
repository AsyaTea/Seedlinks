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
    
    var body: some View {
        NavigationView {
                VStack {
                    Divider()
                    TextField("Write a text", text: $message)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 400, height: 300, alignment: .topLeading)
                    
                    List {
                        Text("Ah scemi")
                        Text("Ah scemi")
                        Text("Ah scemi")
                    }
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                }
                .navigationBarItems(leading: Button(action: {
                    print("Dismissing sheet view...")
                    self.showSheetView = false
                }) {
                    HStack {
                        Text("< Profile").bold()
                    }
                })
                .navigationBarTitle(Text("New seed"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    print("Dismissing sheet view...")
                    self.showSheetView = false
                }) {
                    Text("Publish").bold()
                })
            
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}
