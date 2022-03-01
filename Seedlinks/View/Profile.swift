//
//  Profile.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 28/02/22.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var userSession : UserSession
    @StateObject var dbManager = DatabaseManager()
    @ObservedObject var locationManager : LocationManager
    @State var isOn: Bool = false

    
    var body: some View {
        VStack{
            
            //Welcome back
            HStack{
                
                Text("Garden")
                    .fontWeight(.medium)
                    .font(.system(size:28))
                    .scaledToFit()
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                Spacer()
                NavigationLink(destination: SettingsView(dbManager: dbManager,userSession: userSession),
                               label:{
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .foregroundColor(.accentColor)
                        .frame(width: 25, height: 25)
                })
            }
            
            //Current position
            HStack{
                Image("mapsymbols")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 18)
                if(locationManager.streetName.isEmpty){
                    Text(locationManager.cityName)
                        .foregroundColor(Color("genericGray"))
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
                else{
                    Text(locationManager.streetName)
                        .foregroundColor(Color("genericGray"))
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                }
                Spacer()
            }
            .padding(.top,-5)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(userSession: UserSession(),dbManager: DatabaseManager(),locationManager: LocationManager())
    }
}
