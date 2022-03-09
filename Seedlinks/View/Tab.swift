//
//  Tab.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
import Firebase

let onboardTitle: String = "Leave a sign around the world"

struct Tab: View {
    @State private var appSetupState = "App NOT Setup"
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
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
        .sheet(isPresented:$needsAppOnboarding) {
            
            // Scenario #1: User has NOT completed app onboarding
            TabView{
                OnboardingView(systemImageName: "onboarding1", title: NSLocalizedString(onboardTitle, comment: ""), description: "")
                InfoList(didSetup: true)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        //        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    // .environmentObject(userSession)
}
