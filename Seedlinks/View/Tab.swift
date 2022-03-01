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
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(named: "TabBar")
    }
    @StateObject var dbManager = DatabaseManager()
    @StateObject var userSession = UserSession()
    @ObservedObject var locationManager = LocationManager()
//    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        
        TabView {
            MapView(locationManager: locationManager, dbManager: dbManager, userSession: userSession)
                .tabItem {
                    Image("seed")
                        .renderingMode(.template)
                    Text("Seeds")
                }
            
            
            GardenView( dbManager: dbManager, locationManager:locationManager, userSession: userSession)
                .tabItem {
                    Image("garden")
                        .renderingMode(.template)
                    Text("Garden")
                }
        }
//        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    // .environmentObject(userSession)
}


