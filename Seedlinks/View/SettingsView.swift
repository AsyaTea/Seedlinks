//
//  SettingsView.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 20/02/22.
//

import SwiftUI


struct SettingsView: View {
    
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var userSession : UserSession
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        
        VStack{
            List{
                Section{
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .cornerRadius(10)
                                .foregroundColor(.red)
                            SwiftUI.Image(systemName:"bell.badge")
                        }
                        Text("Notification")
                            .fontWeight(.regular)
                    }
                    Toggle(isOn: $isDarkMode) {
                        ZStack{
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                            SwiftUI.Image(systemName:"sun.max")
                        }
                        Text("Dark Mode")
                            .fontWeight(.regular)
                    }
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width: 36, height: 36)
                                .cornerRadius(10)
                                .foregroundColor(.green)
                            SwiftUI.Image(systemName:"network")
                        }
                        Text("Language")
                            .fontWeight(.regular)
                    }
                    
                }header: {
                    Text("General")
                }
                
                Section{
                    Button(role:.destructive,action: {
                        userSession.isLogged = false
                        userSession.userAuthenticatedId = ""
                        dbManager.userList.removeAll()
                    }, label: {
                        Text("Log out")
                    })
                }header: {
                    Text("User")
                }
                
                
                
            }.listStyle(.inset)
            Text("Version 1.0")
                .padding()
            
            
        }  .navigationTitle("Settings")
        
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SettingsView(isDarkMode: true)
//    }
//}
