//
//  PrivacyPolicy.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import Foundation
import SwiftUI


struct PolicyView: View {
    let HTMLFile = "Policy.html"
    var body: some View {
        VStack{
            HTMLView(htmlFileName: HTMLFile)
        }.frame(width: 400.0, height: 800.0)
    }
}
struct ContentView_Previews7: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
