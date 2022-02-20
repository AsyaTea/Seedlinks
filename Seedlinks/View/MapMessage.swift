//
//  MapMessage.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 20/02/22.
//

import SwiftUI

struct MapMessage: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 250, height: 40)
        Text("Hello, World!")
        }
    }
}

struct MapMessage_Previews: PreviewProvider {
    static var previews: some View {
        MapMessage()
    }
}
