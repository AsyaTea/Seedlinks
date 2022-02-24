//
//  MessageView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI

let actionTriggered: String = "Action 1 triggered"
let delDatabase: String = "Deleting from database"
struct ContentLengthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
    
}

struct MessageView: View {
    
    let messageId: String
    var messageText : String
    let messageAuthor: String
    let pubblicationDate: Date
    let dateString: String
    var category: String
    var anonymous: Bool
    let longitude: String
    let latitude: String
    @State var textHeight: CGFloat = 0
    
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var userSession : UserSession
    
    
    
    var body: some View {
        ZStack{
            //Shadow
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(.gray)
                .opacity(0.2)
                .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+65,alignment: .leading)
                .blur(radius: 10)
            
            //Rect
            if category == "Advice" {
                RoundedRectangle(cornerRadius:10)
                    .foregroundColor(.green)
                    .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+65,alignment: .leading)
            } else if category == "Message" {
                RoundedRectangle(cornerRadius:10)
                    .foregroundColor(.orange)
                    .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+65,alignment: .leading)
            } else if category == "Consiglio" {
                RoundedRectangle(cornerRadius:10)
                    .foregroundColor(.green)
                    .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+65,alignment: .leading)
            } else if category == "Messaggio" {
                RoundedRectangle(cornerRadius:10)
                    .foregroundColor(.orange)
                    .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+65,alignment: .leading)
            }
            else{
                RoundedRectangle(cornerRadius:10)
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+65,alignment: .leading)
            }
            
            
            VStack(alignment: .leading){
                //Nickname
                if anonymous == true {
                    Text("Anonymous")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                } else {
                    Text(dbManager.username)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                }
                
                //Message
                Text(messageText)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .overlay(
                        GeometryReader { proxy in
                            Color
                                .clear
                                .preference(key: ContentLengthPreference.self,
                                            value: proxy.size.height) // <-- this
                        }
                    )
                
                //TIME STAMP
                //                Text(DatabaseManager().formatting(date: pubblicationDate))
                Text(dateString)
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .padding(.top,-5)
                
            }.frame(width: UIScreen.main.bounds.width * 0.85,alignment: .leading)
                .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
                    DispatchQueue.main.async {
                        self.textHeight = value
                    }
                }
        } .contextMenu
        {
            Button(action: {
                
                //Devo fare una navigation e settare le coordinate attuali a quelli del messaggio
                //DEVO PROBABILMENTE FARE UN RETRIEVE DELLE COORDINATE DEL MEX DAL DB E POI SETTARLE
                //PROBLEMA MESSAGE ID
                dbManager.getMessageIdUserQuery(messageID: messageId)
                locationManager.setRegion(latitude: Double(dbManager.messageUser.latitude) ?? 0.0, longitude: Double(dbManager.messageUser.longitude) ?? 0.0)
                print(dbManager.messageUser.latitude,dbManager.messageUser.longitude)
                
                print(NSLocalizedString(actionTriggered, comment: ""))
                
            }
                   , label:
                    {
                NavigationLink(destination: MapView(locationManager: locationManager,dbManager: dbManager, userSession:userSession)){
                    HStack{
                        
                        Text("View on map")
                        Image(systemName: "map")
                    }
                }
            })
            
            Button(role: .destructive ,action: {
                print(NSLocalizedString(delDatabase, comment: ""))
                dbManager.deleteMessage(messageId)
            }, label:
                    {
                HStack{
                    Text("Delete")
                    Image(systemName: "trash")
                }
            })
        }
    }
    
}


//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(message: Message?, messageText: "PROVA", messageAuthor: "PROVA", pubblicationDate: Date.now, dateString: "MOBASTA", category: "message", anonymous: true)
//    }
//}
