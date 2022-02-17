//
//  Tab.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {

    let auth: Auth

    public var isLogged: Bool = false
    public var userAuthenticatedId: String = ""

    static let shared = FirebaseManager()

    override init() {
        

        self.auth = Auth.auth()

        super.init()
    }
}

class UserSession: ObservableObject {
    @Published var isLogged: Bool = false
    @Published var userAuthenticatedId: String = ""
    
}


struct Tab: View {
    
    init() {
        
       UITabBar.appearance().barTintColor = UIColor(named: "genericGray")
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
            
            if userSession.isLogged {
                GardenView(userSession: userSession, dbManager: dbManager,username: userSession.userAuthenticatedId)
                    .tabItem {
                        Image("garden")
                            .renderingMode(.template)
                        Text("Garden")
                    }
            } else {
                LoginView(userSession: userSession)
                    .tabItem {
                        Image("garden")
                            .renderingMode(.template)
                        Text("Garden")
                    }
                    
            }
                
        }
        .environmentObject(userSession)
    }
}


