//
//  Login-View.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 17/02/22.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @ObservedObject var userSession : UserSession
    @ObservedObject var dbManager : DatabaseManager
    var body: some View {
       
        
            SignInView(dbManager: dbManager, userSession: userSession)
    
    }
}

struct SignInView: View {
    
    @ObservedObject var dbManager : DatabaseManager
    @ObservedObject var userSession : UserSession
    @State var email: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                authenticationDidFail = true
                return
            }
            let userID = result?.user.uid ?? ""
            print("Successfully logged in as user: \(userID)")
            authenticationDidSucceed = true
            userSession.isLogged = true
            userSession.userAuthenticatedId = userID
            dbManager.getUsername(userID: userID)
            
        }
    }
    
    var body: some View {
      
       
        VStack {
            Text("Welcome back")
                .font(.system(size: 40))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Text("You have been missed")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .padding(.top,5)
            Spacer()
     //       Divider()
            
            VStack {
                Text("  ")
                emailTextField(email: $email)
                PasswordSecureField(password: $password)
                if authenticationDidFail {
                    Text("Information not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                NavigationLink(destination: PasswordRecovery(userSession: userSession)){
                    Text("Forgotten password?")
                    .fontWeight(.thin)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 390, height: 30, alignment: .trailing)
                    .onTapGesture {
                    }
                }
            
                
                
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    loginUser()
                    
                    
                }) {
                    LoginButtonContent()
                }
            }
            .padding()
            if authenticationDidSucceed {
                Text("Login succeeded!")
                    .font(.headline)
                    .frame(width: 250, height: 80)
                    .background(Color.green)
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .animation(Animation.linear(duration: 1), value: 1.5)
            }
            //                HStack{
            //                    Rectangle()
            //                        .frame(width: 50.0, height: 1.0)
            //                    Text("Or continue with")
            //                    Rectangle()
            //                        .frame(width: 50.0, height: 1.0)
            //
            //                }
            //                SignInWithAppleButton(
            //                    onRequest: { request in
            //                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
            //                    },
            //                    onCompletion: { result in
            //                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
            //                    }
            //                )
            //                    .frame(width: 200.0, height: 40.0)
            //                    .cornerRadius(10)
            //                    .padding()
            
            HStack{
                Text("Not a member?")
                NavigationLink(destination: RegisterView(userSession: userSession)) {
                    Text("Register now!")
                        .foregroundColor(.accentColor)
                }
                //                    .navigationTitle("Sign in")
                
            }
            Spacer()
        }
        //            NavigationLink(destination: FolderList(id: workFolder.id)) {
        //                Label("Work Folder", systemImage: "folder")
        //            }
        
        //        .navigationBarBackButtonHidden(true)
        //  .frame(width: 400.0, height: 800.0)
        
    
    }
    
    
}

struct LoginButtonContent : View {
    var body: some View {
        Text("Sign in")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.accentColor)
            .cornerRadius(10.0)
    }
}



struct emailTextField : View {
    
    @Binding var email: String
    
    var body: some View {
      
            TextField("name@example.com", text: $email)
            .cornerRadius(10)
                .underlineTextField()
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    
    var body: some View {
        return SecureField("Password", text: $password)
            .cornerRadius(10.0)
            .underlineTextField()
    }
}

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(Color("Inverso"))
            .background(Color("TabBar"))
            .padding(10)
    }
}

struct PasswordRecovery: View {
    @ObservedObject var userSession : UserSession
    @State var email = ""
    var body: some View {
        
        VStack {
            Text("Email por favor")
            emailTextField(email: $email)
            Button(action: {
                userSession.passwordReset(email: email)
            }, label: {
                Text("Send reset password")
            })
        
        }
        
    }
}


//struct ContentView_Previews5: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
