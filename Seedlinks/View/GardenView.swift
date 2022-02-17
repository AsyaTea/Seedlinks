//
//  GardenView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
    

struct GardenView: View {
   
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var userSession : UserSession
   
    var body: some View {
       
        if userSession.isLogged{
            ProfileView(userSession: userSession, dbManager: dbManager)
        }
        else{
            LoginView(userSession: userSession)
        }
      
        }
        
    
    
}

//struct GardenView_Previews: PreviewProvider {
//    static var previews: some View {
//        GardenView()
//    }
//}
