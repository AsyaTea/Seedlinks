//
//  PrivacyPolicy.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import Foundation
import SwiftUI


struct PolicyView: View {
    var body: some View {
        HTMLView(htmlFileName: "Policy")
            .frame(width: 400.0, height: 700.0)
        }
}
struct ContentView_Previews7: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}
