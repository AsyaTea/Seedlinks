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
    
    @State var textHeight: CGFloat = 0
    
    var body: some View {
        ZStack{
            //Shadow
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(.black)
                .opacity(0.2)
                .frame(width: 333, height: textHeight+65,alignment: .leading)
                .blur(radius: 10)
            
            //Rect
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(.green)
                .frame(width: 333, height: textHeight+65,alignment: .leading)
            
            VStack(alignment: .leading){
                //Nickname
                Text("Anonymous")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                
                //Message
                Text("Il decò è un furto, non ci andate !!!!!!dsfdsfdsfsfddsffdsdfdsfdsfdfsfdsfsddsfdsfdsdsfdsfdsfsdfdsfdsfdsfdsfdsfdsfdsfdsfdsfdssff SDHFJDSFHDSFJHDJSHFJHDSHFHJSDHJFHJDSHJFS")
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
                Text("2h ago")
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
            
            Button(role: .destructive ,action: { print("action 2 triggered")}, label:
            {
                HStack{
                    Text("Delete")
                    Image(systemName: "trash")
                }
            })
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
