//
//  NewMessageView.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 14/02/22.
//

import SwiftUI
import MapKit
import Combine

let cat1 = "Message"
let cat2  = "Advice"
struct SheetView: View {
    
    @ObservedObject var userSession: UserSession
    @State var message = ""
    @State var placeholder = "Write something..."
    @Binding var showSheetView: Bool
    @State private var selectedCategory = ""
    @State private var anonymous = false
    @State private var privat = false
    
    var categories = [NSLocalizedString(cat1, comment: ""), NSLocalizedString(cat2, comment: "")]
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var locationManager : LocationManager
    
    //Text limit
    let textLimit = 250
    
    //Function to keep text lenght in limits
    func limitText(_ upper: Int) {
        if message.count > upper {
            message = String(message.prefix(upper))
        }
    }
    
    //Dismiss keyboard
    @FocusState private var isFocused: Bool
    
    //LABEL FOR CATEGORY MENU
    var customLabel: some View {
           HStack {
               Text("Select a category:")
                   .foregroundColor(.accentColor)
               Text(String(selectedCategory))
                   .foregroundColor(.primary)
               Spacer()
           }
           .font(.system(size: 17))
//           .frame(height: 32)
       }
    
    var body: some View {
        
        let coordinate : CLLocationCoordinate2D = self.locationManager.lastLocation!.coordinate
        
        NavigationView {
            ScrollView(showsIndicators: false){
                Group {
                    
                    ZStack{
                        if message.isEmpty{
                            Text(placeholder)
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.43, alignment: .topLeading)
                                .foregroundColor(Color("genericGray"))
                                .disabled(true)
                                .padding()
                        }
                        TextEditor(text: $message)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                            .opacity(message.isEmpty ? 0.25 : 1)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.43, alignment: .topLeading)
                            .padding()
                            .onReceive(Just(message)) {_ in limitText(textLimit)}
                        //DISMISS KEYBOARD
                            .toolbar {
                                ToolbarItem(placement: .keyboard){
                                    Button{
                                        isFocused = false
                                    }
                                label:{
                                    Image(systemName: "keyboard.chevron.compact.down")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    HStack{
                        Spacer()
                        Text(String(message.count) + " / " + String(textLimit))
                            .font(.subheadline)
                            .foregroundColor(Color("genericGray"))
                        
                    }
                    .padding()
                    VStack{
                        Divider()
                        HStack{
                            Text("Properties")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        HStack{
                            Menu{
                                Picker(selection: $selectedCategory,label:EmptyView()) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            Spacer()
                        }label: {
                            customLabel
                        }

                        }
                        Divider()
                        Toggle("Anonymous", isOn: $anonymous)
                        HStack{
                            Text("Other users will not be able to see your username")
                                .fontWeight(.thin)
                                .foregroundColor(Color("genericGray"))
                                .font(.subheadline)
                                .padding(.top,-3)
                            Spacer()
                        }
                        Divider()
                        Toggle("Private", isOn: $privat)
                        HStack{
                            Text("This message will not be visible by other users")
                                .foregroundColor(Color("genericGray"))
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .padding(.top,-3)
                            Spacer()
                        }
                        
                    }.padding()
                    
                    Divider()
                    HStack{
                        Text("Current location")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                    }.padding()
                    MapModal(locationManager: locationManager)
                        .cornerRadius(20)
                        .frame(width: UIScreen.main.bounds.width * 0.91, height: 150)
                        .disabled(true)
                      
                    if(locationManager.streetName.isEmpty){
                        HStack{
                            Text(locationManager.cityName)
                                .font(.callout)
                                .fontWeight(.medium)
                            // Spacer()
                        }
                    }
                    else{
                        Text(locationManager.cityName + " - " + locationManager.streetName)
                            .font(.callout)
                            .fontWeight(.regular)
                    }
                }.padding()
            }.onAppear{
                locationManager.reverseGeoMessage(latitude: coordinate.latitude,longitude: coordinate.longitude)
            }
            
            .navigationBarItems(leading: Button(action: {
                self.showSheetView = false
            }) {
                Text("Cancel")
            })
            .navigationBarTitle(Text("New seed"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSheetView = false
                dbManager.addMessage(
                    userID: userSession.userAuthenticatedId,
                    author: dbManager.user?.username ?? dbManager.username,
                    message: message,
                    publicationDate: Date.now,
                    dateString: DatabaseManager().formatting(date: Date.now),
                    category: selectedCategory,
                    anonymous: anonymous,
                    privat: privat,
                    latitude:String(coordinate.latitude),
                    longitude:String(coordinate.longitude),
                    reportCount: 0,
                    locationName: locationManager.streetNameMessage.isEmpty ? locationManager.cityNameMessage : locationManager.streetNameMessage
                )
                dbManager.userMessagesQuery(userID: userSession.userAuthenticatedId)
                
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


