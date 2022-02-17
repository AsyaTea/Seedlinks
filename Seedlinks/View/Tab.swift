//
//  Tab.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
import Firebase


struct Tab: View {
    
    init() {
    
        UITabBar.appearance().barTintColor = UIColor(.white)
    }
    @StateObject var dbManager = DatabaseManager()
    @StateObject var userSession = UserSession()
   
    var body: some View {
                     
        TabView {
            MapView()
                .tabItem {
                    Image("seed")
                        .renderingMode(.template)
                    Text("Seeds")
                }
            
           
            GardenView(dbManager: dbManager, userSession: userSession)
                    .tabItem {
                        Image("garden")
                            .renderingMode(.template)
                        Text("Garden")
                    }
            }
                
        }
       // .environmentObject(userSession)
    }


