//
//  RectangleNotInRadius.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 01/03/22.
//

import SwiftUI

struct RectangleNotInRadius: View {
    
    let messageId: String
    var messageText : String
    let messageAuthor: String
    let pubblicationDate : Date
    let dateString: String
    var category: String
    var anonymous: Bool
    var privat: Bool
    let longitude: String
    let latitude: String
    let locationName : String
    @State var textHeight: CGFloat = 0
    
    var body: some View {
        ZStack{
        RoundedRectangle(cornerRadius:10)
            .foregroundColor(Color("notInRadius"))
            .frame(width: UIScreen.main.bounds.width * 0.91, height: textHeight+75,alignment: .leading)
//            .shadow(color: Color("shadowColor").opacity(0.2), radius: 5, x: 0, y: 2)
//            .shadow(color: Color("shadowColor").opacity(0.2), radius: 20, x: 0, y: 10)
            
            VStack(alignment: .leading){
                //Anonymous button
                HStack{
                if anonymous == true {
                    ZStack{
                        Rectangle()
                            .cornerRadius(12)
                            .frame(width: UIScreen.main.bounds.width * 0.24,height:20)
                            .foregroundColor(Color("TagNotRadius"))
                        Text("Anonymous")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color("TabBar"))
                    }
                }
                    if privat == true{
                        ZStack{
                            Rectangle()
                                .cornerRadius(12)
                                .frame(width: UIScreen.main.bounds.width * 0.24,height:20)
                                .foregroundColor(Color("TagNotRadius"))
                            Text("Private")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .foregroundColor(Color("TabBar"))
                        }
                    }
                }
                //Message
                Text(messageText)
                    .foregroundColor(Color("TextNotRadius"))
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
                HStack{
                    //POSITION
                    Text(locationName)
                        .foregroundColor(Color("dateLocal"))
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                    
                    Spacer()
                    //TIME STAMP
                    Text(dateString)
                        .foregroundColor(Color("dateLocal"))
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .padding(.top,-5)
                }.frame(width: UIScreen.main.bounds.width * 0.83,alignment: .leading)
                
            }.frame(width: UIScreen.main.bounds.width * 0.85,alignment: .leading)
                .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
                    DispatchQueue.main.async {
                        self.textHeight = value
                    }
                }
        }
    }
}

//struct RectangleNotInRadius_Previews: PreviewProvider {
//    static var previews: some View {
//        RectangleNotInRadius()
//    }
//}
