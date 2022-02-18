//
//  ProfileView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 17/02/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSession : UserSession
    @ObservedObject var dbManager : DatabaseManager
    @StateObject var locationManager = LocationManager()
    @State var isOn: Bool = false
    var username : String = ""
   
    var body: some View {
       
        
        VStack(alignment: .leading){
            Text("Welcome back" + String(dbManager.user?.username ?? " default"))
                .fontWeight(.semibold)
                .font(.system(size: 28))
                .padding(.top,30)
            HStack{
                Image("mapsymbols")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 18)
                //INSERT CURRENT LOCATION
                Text("Via Nicolangelo Protopisani 21")
                    .foregroundColor(Color("genericGray"))
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }.padding(.top,-15)
            
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
                }.sheet(isPresented: $isOn) {
                    SheetView(userSession: userSession, showSheetView: self.$isOn,dbManager: dbManager, locationManager: locationManager)
                  
                }
            
            Button(action: {
                userSession.isLogged = false
                userSession.userAuthenticatedId = ""
                
            }, label: {
                Text("LOG OUT")
            })
            
                
            //YOUR SEEDS
            VStack(alignment: .leading) {
                Text("Your seeds")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .padding(.top,20)
                ScrollView{
                    MessageListView(userSession: userSession, dbManager: dbManager)
                }
                           
            }
            Spacer()
        }
//        .onAppear{
//            dbManager.fetchCurrentUser()
//        }
        }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
