//
//  RegisterView.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import Foundation
import SwiftUI
import AuthenticationServices



struct RegisterView: View {
    
    
    @StateObject var dbManager = DatabaseManager()
    @ObservedObject var userSession : UserSession
    
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var registrationDidFail: Bool = false
    @State var registrationDidSucceed: Bool = false
    @State var errorString : String = ""
    @State var showingAlert = false
    
    private func createNewAccount() {
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                errorString = err.localizedDescription
                registrationDidFail = true
                return
            }
            let userID = result?.user.uid ?? ""
            print("Successfully created user: \(userID)")
            dbManager.addUser(userID: userID, username: username, email: email)
            
            registrationDidSucceed = true
            
        }
    }
    
    
    var body: some View {
        
        VStack {
            
            Text("Get started!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Text("Use your email to create an account")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .padding(.top,2)
            Spacer()
            VStack {
                Text("Username")
                    .font(.caption)
                    .padding(.top, 30.0)
                    .frame(width: 370, height: 10, alignment: .leading)
                UsernameTextField(username: $username)
                Text("E-mail")
                    .font(.caption)
                    .padding(.top, 30.0)
                    .frame(width: 370, height: 10, alignment: .leading)
                emailTextField(email: $email)
                Text("Password")
                    .font(.caption)
                    .padding(.top, 30.0)
                    .frame(width: 370, height: 10, alignment: .leading)
                PasswordSecureField(password: $password)
                if registrationDidFail {
                    Text(errorString)
                        .foregroundColor(.red)
                }
            }
            
            Button(action: {
                //                        guard !email.isEmpty(email: email, password: password)
                createNewAccount()
            }) {
                RegisterButtonContent()
            }
            //                    .disabled()
            Spacer()
        }.alert("Registration completed", isPresented: $registrationDidSucceed) {
            Button("Ok", role: .cancel) { }
        }
        
        
        HStack {
            Text("By registering, you agree to our")
            NavigationLink(destination: PolicyView())
            {Text("privacy policy")
                    .foregroundColor(Color("AccentColor"))
            }
        }
        HStack{
            Text("and our")
            NavigationLink(destination: TTCView())
            {Text("terms and conditions.")
                    .foregroundColor(Color("AccentColor"))
            }
            
        }
        Spacer()
    }//.frame(width: 400.0, height: 850.0)
    
    //                .navigationBarBackButtonHidden(true)
    
}


struct RegisterButtonContent : View {
    var body: some View {
        return Text("Register")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 320, height: 60)
            .background(Color.accentColor)
            .cornerRadius(10.0)
    }
}

struct UsernameTextField : View {
    
    @Binding var username: String
    
    var body: some View {
        TextField("Username", text: $username)
            .cornerRadius(10.0)
            .underlineTextField()
        
    }
}

//struct ContentView_Previews6: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
