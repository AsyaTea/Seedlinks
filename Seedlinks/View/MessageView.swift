//
//  MessageView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI


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
    @State var textHeight: CGFloat = 0
    @StateObject var dbManager = DatabaseManager()
    
    var body: some View {
        ZStack{
            //Shadow
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(.black)
                .opacity(0.2)
                .frame(width: 333, height: textHeight+65,alignment: .leading)
                .blur(radius: 10)
            
            //Rect
            if category == "advice" {
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(.green)
                .frame(width: 333, height: textHeight+65,alignment: .leading)
            } else if category == "message" {
                RoundedRectangle(cornerRadius:10)
                    .foregroundColor(.orange)
                    .frame(width: 333, height: textHeight+65,alignment: .leading)
            }
            
            
            VStack(alignment: .leading){
                //Nickname
                if anonymous == true {
                    Text("Anonymous")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                } else {
                    Text(messageAuthor)
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
                
            }.frame(width: 300,alignment: .leading)
            .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
                DispatchQueue.main.async {
                    self.textHeight = value
                }
            }
        } .contextMenu
        {
            Button(action: { print("Action 1 triggered") }, label:
            {
                HStack{
                    Text("View on map")
                    Image(systemName: "map")
                }
            })
            
            Button(role: .destructive ,action: {
                print("action 2 triggered")
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
