//
//  ListView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI

struct ListView: View {
    @State var textHeight: CGFloat = 0
    
    var body: some View {
        VStack{
            ZStack{
                
                //Rect
                RoundedRectangle(cornerRadius:10)
                    .stroke(Color.green,lineWidth: 2)
                    .foregroundColor(.white)
                    .frame(width: 333, height: textHeight+65,alignment: .leading)
                
                VStack(alignment: .leading){
                    //Nickname
                    Text("Michele Carro")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    //Message
                    Text("Il decò è un furto, non ci andate")
                        .foregroundColor(.black)
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
                        .foregroundColor(Color("genericGray"))
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .padding(.top,-5)
                    
                }.frame(width: 300,alignment: .leading)
                    .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
                        DispatchQueue.main.async {
                            self.textHeight = value
                        }
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Seeds")
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
