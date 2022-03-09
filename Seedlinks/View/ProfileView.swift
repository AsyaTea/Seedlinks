//
//  ProfileView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 17/02/22.
//

import SwiftUI

let filterDate: String = "Date"
let filterDistance: String = "Distance"

struct ProfileView: View {
    
    @ObservedObject var userSession : UserSession
    @StateObject var dbManager = DatabaseManager()
    @ObservedObject var locationManager : LocationManager
    @State var isOn: Bool = false
    var username : String = ""
    @State private var selectedCategory = ""
    var filtering = [NSLocalizedString(filterDate, comment: ""), NSLocalizedString(filterDistance, comment: "")]
    
    var customLabel: some View {
        HStack {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .resizable()
                .frame(width:19,height: 19)
//            Spacer()
        }
        .font(.body)
        //           .frame(height: 32)
    }
    
    var body: some View {
        
        VStack{
            
            //Welcome back
            HStack{
                //                Text("Welcome back " + String(dbManager.user?.username ?? dbManager.username))
                Text("Garden")
                    .fontWeight(.bold)
                    .font(.title)
                    .scaledToFit()
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                Spacer()
                NavigationLink(destination: SettingsView(dbManager: dbManager,userSession: userSession),
                               label:{
                    Image(systemName: "gearshape")
                        .resizable()
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
                        .font(.callout)
                        .fontWeight(.medium)
                }
                else{
                    Text(locationManager.streetName)
                        .foregroundColor(Color("genericGray"))
                        .font(.callout)
                        .fontWeight(.medium)
                }
                Spacer()
            }
            .padding(.top,-7)
            
            //Plant a seed
            Button {
                isOn = true
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius:30)
                    // .stroke(Color.green,lineWidth: 2)
                        .foregroundColor(.green)
                        .frame(width: UIScreen.main.bounds.width * 0.91, height: 50)
                    Text("+ Plant a seed")
                    // .foregroundColor(Color("genericGray"))
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width * 0.86, height: 40, alignment: .center)
                    
                    
                }
                .padding(.top,15)
            }
            .sheet(isPresented: $isOn) {
                SheetView(userSession: userSession, showSheetView: self.$isOn,dbManager: dbManager, locationManager: locationManager)
            }
            
            // MARK: Your seeds
            HStack{
                Text("Your seeds")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    MessageListView(userSession: userSession, dbManager: dbManager, locationManager: locationManager).orderByDistance()
                }, label: {
                    Text("Sort")
                })
                Menu{
                    Picker(selection: $dbManager.selectedCategory,label:EmptyView()){
                        ForEach(dbManager.filtering, id: \.self) {
                            Text($0)
                        }
                    }
                }label: {
                    customLabel
                }
            }.padding(.top,20)
            
            
                ScrollView(showsIndicators: false){
                    MessageListView(userSession: userSession, dbManager: dbManager, locationManager: locationManager)
                        .frame(alignment:.center)
                }
                      
            Spacer()
        }
        .navigationBarHidden(true)
        .padding([.top, .leading, .trailing], 15.0)
        .onAppear {
            dbManager.getUsername(userID: userSession.userAuthenticatedId)
          
        }
        
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(
//            userSession: UserSession(),dbManager: DatabaseManager(),locationManager: LocationManager())
//    }
//}
