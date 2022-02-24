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
        HTMLView(htmlFileName: "TTC")
            .frame(width: 400.0, height: 770.0)
    }
}
struct ContentView_Previ: PreviewProvider {
    static var previews: some View {
        TTCView()
    }
}

