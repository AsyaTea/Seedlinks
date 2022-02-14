//
//  Tab.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI

struct Tab: View {
    
    init() {
        //UITabBar.appearance().isTranslucent = false
       UITabBar.appearance().barTintColor = UIColor(named: "genericGray")
    }
    
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Image("seed")
                        .renderingMode(.template)
                    Text("Seeds")
                }
            
            GardenView()
                .tabItem {
                    Image("garden")
                        .renderingMode(.template)
                    Text("Garden")
                }
        }
        
    }
}

