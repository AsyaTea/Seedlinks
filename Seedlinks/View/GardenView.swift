//
//  GardenView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 14/02/22.
//

import SwiftUI
    

struct GardenView: View {
   
    @ObservedObject var userSession : UserSession
    @ObservedObject var dbManager : DatabaseManager
    @State var isOn: Bool = false
    var username : String = "Ivo"
   
   // @ObservedObject var dbManager : dbManager
    @StateObject var dbManager = DatabaseManager()
    var body: some View {
       
        
        VStack(alignment: .leading){
            Text("Welcome back \(username)")
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
                    SheetView(userSession: userSession, showSheetView: self.$isOn,dbManager: dbManager)
                  
                }
            
            Button(action: {
             
                
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
                    MessageListView(dbManager: dbManager)
                }
                           
            }
            Spacer()
        }.onAppear{
//            dbManager.getUsername(userID: userSession.userAuthenticatedId)
        }
        }
        
    
    
}

//struct GardenView_Previews: PreviewProvider {
//    static var previews: some View {
//        GardenView()
//    }
//}
