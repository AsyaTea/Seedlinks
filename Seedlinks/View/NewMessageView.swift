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
    
    @Binding var showSheetView: Bool
    
    var body: some View {
        NavigationView {
            Text("Sheet View content")
                .navigationBarItems(leading: Button(action: {
                    print("Dismissing sheet view...")
                    self.showSheetView = false
                }) {
                    HStack {
//                        Image(systemName: "􀆁")
                        Text("Profile").bold()
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
