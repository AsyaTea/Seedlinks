//
//  ProfileView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 17/02/22.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var userSession : UserSession
    @StateObject var dbManager = DatabaseManager()
    @StateObject var locationManager = LocationManager()
    @State var isOn: Bool = false
    var username : String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Welcome back")
                    .fontWeight(.medium)
                   // .font(.system(size: 28))
                    .font(.system(size: 500))
                    .minimumScaleFactor(0.01)
                  //  .padding(.top,30)
                Text(dbManager.user?.username ?? dbManager.username)
                    .fontWeight(.medium)
                    .font(.system(size: 28))
                   // .padding(.top,30)
                Spacer()
                NavigationLink(destination: SettingsView(dbManager: dbManager,userSession: userSession),
                    label:{
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .foregroundColor(.accentColor)
                            .frame(width: 25, height: 25)
                    })
            }.padding()
            
            VStack{
                
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
                }.padding(.top,-10)
                
                Button {
                    isOn = true
                } label: {
                    ZStack{
                        Text("Plant a seed.")
                            .foregroundColor(Color("genericGray"))
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                            .frame(width: 303, height: 40, alignment: .leading)
                        
                        RoundedRectangle(cornerRadius:10)
                            .stroke(Color.green,lineWidth: 2)
                            .foregroundColor(.white)
                            .frame(width: 333, height: 44)
                    }.padding(.top,10)
                        .frame(alignment:.center)
                }.sheet(isPresented: $isOn) {
                    SheetView(userSession: userSession, showSheetView: self.$isOn,dbManager: dbManager, locationManager: locationManager)
                    
                }
                                
                
                //YOUR SEEDS
                VStack(alignment: .leading) {
                    Text("Your seeds")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .padding(.top,20)
                    ScrollView(showsIndicators: false){
                        MessageListView(userSession: userSession, dbManager: dbManager, locationManager: locationManager)
                            .frame(alignment:.center)
                            
                    }
                    
                }
                Spacer()
            }.navigationBarHidden(true)
                .onAppear{
                    locationManager.reverseGeo(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0.0,longitude: locationManager.lastLocation?.coordinate.longitude ?? 0.0)
                }
                .padding()
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(
//            userSession: UserSession(isLogged:true,userAuthenticatedId: "",userAuthUsername: "Default")
//            
//            )
//            
//    }
//}
