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
    @State var isOn: Bool = false
    @State var isOn2: Bool = false
    
    @State var showingAlert = false
    
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
                    Button("Terms of Service"){
                        isOn2 = true
                    } .sheet(isPresented: $isOn2) {
                        TTCView()
                    }
                    Button("Privacy Policy"){
                        isOn = true
                    } .sheet(isPresented: $isOn) {
                        PolicyView()
                    }
                }header: {
                    Text("Privacy")
                }
                Section{
                    Button(role:.destructive,action: {
                        userSession.isLogged = false
                        userSession.userAuthenticatedId = ""
                        dbManager.userList.removeAll()
                        userSession.logOut()

                    }, label: {
                        Text("Log out")
                    })
                    Button(role:.destructive,action: {
                       
                        print(userSession.userAuthenticatedId)
                        showingAlert = true
                       
                    }, label: {
                        Text("Delete Account")
                    })
                        .alert(isPresented:$showingAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete your account?"),
                            message: Text("There is no undo"),
                            primaryButton: .destructive(Text("Delete")) {
                                dbManager.userList.removeAll()
                                dbManager.deleteUserDatabase(userID: dbManager.userDocumentID)
                                dbManager.deleteAllUserMessages(userID: userSession.userAuthenticatedId)
//                                userSession.logOut()
                                userSession.deleteUser()
                                           
                                print("Deleting...")
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }header: {
                    Text("User")
                }
                
            }.listStyle(.inset)
            Text("Version 1.5")
                .padding()
            
        } .navigationTitle("Settings")
    }
}

//struct SettingsView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SettingsView(isDarkMode: true)
//    }
//}
