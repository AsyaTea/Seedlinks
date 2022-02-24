//
//  GardenView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI


struct GardenView: View {
    
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var locationManager : LocationManager
    @ObservedObject var userSession : UserSession
    
    var body: some View {
        NavigationView
        {
            if userSession.isLogged
            {
                ProfileView(userSession: userSession, dbManager: dbManager,locationManager: locationManager)
                    .onAppear{
                        locationManager.reverseGeo(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0.0,longitude: locationManager.lastLocation?.coordinate.longitude ?? 0.0)
                    }
            }
            else
            {
                LoginView(userSession: userSession, dbManager: dbManager)
            }
        }
    }
}

//struct GardenView_Previews: PreviewProvider {
//    static var previews: some View {
//        GardenView()
//    }
//}
