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
                        }
                        
                        TextEditor(text: $message)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isFocused)
                            .opacity(message.isEmpty ? 0.25 : 1)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.43, alignment: .topLeading)
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
                            .foregroundColor(Color("genericGray"))
                        
                    }
                    .padding()
                    VStack{
                        Divider()
                        HStack{
                            Text("Propreties")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                            Spacer()
                        }
                        Toggle("Anonymous", isOn: $anonymous)
                        HStack{
                            Text("Other users will not be able to see your username")
                                .fontWeight(.thin)
                                .foregroundColor(Color("genericGray"))
                                .font(.system(size: 14))
                            Spacer()
                        }
                        
                        Toggle("Private", isOn: $privat)
                        HStack{
                            Text("This message will not be visibile by other users")
                                .foregroundColor(Color("genericGray"))
                                .font(.system(size: 14))
                                .fontWeight(.thin)
                            Spacer()
                        }
                        HStack{
                            Picker("Choose a category", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                    Divider()
                    HStack{
                        Text("Current location")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                        Spacer()
                    }
                    MapModal(locationManager: locationManager)
                        .cornerRadius(20)
                        .frame(width: UIScreen.main.bounds.width * 0.91, height: 150)
                        .disabled(true)
                      
                    if(locationManager.streetName.isEmpty){
                        HStack{
                            //                            Text("You are leaving a message at: ")
                            //                                .font(.system(size: 16))
                            //                                .fontWeight(.regular)
                            Text(locationManager.cityName)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                            // Spacer()
                        }
                    }
                    else{
                        Text(locationManager.streetName)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                    }
                }.padding()
            }
            
            .navigationBarItems(leading: Button(action: {
                self.showSheetView = false
            }) {
                Text("Cancel")
            })
            .navigationBarTitle(Text("New seed"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSheetView = false
                dbManager.addMessage(userID: userSession.userAuthenticatedId, author: dbManager.user?.username ?? dbManager.username, message: message, publicationDate: Date.now, dateString: DatabaseManager().formatting(date: Date.now), category: selectedCategory, anonymous: anonymous, privat: privat, latitude:String(coordinate.latitude) ,longitude:String(coordinate.longitude),
                                     reportCount: 0 )
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


