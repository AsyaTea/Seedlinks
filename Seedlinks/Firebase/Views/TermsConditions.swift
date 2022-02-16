//
//  TermsConditions.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import Foundation
import SwiftUI


struct TTCView: View {
    
    var body: some View {
        
        ScrollView{
            VStack {
                Text("Terms and conditions")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(width: 390, alignment: .leading)
                Text("his Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.")
                    .font(.body)
                    .fontWeight(.regular)
                    .padding()
                    .frame(width: 390, alignment: .leading)
            }
        }.frame(width: 400.0, height: 800.0)
    }
}
struct ContentView_Previe: PreviewProvider {
    static var previews: some View {
        TTCView()
    }
}

