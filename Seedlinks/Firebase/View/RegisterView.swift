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
   
 
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @State var registrationDidFail: Bool = false
    @State var registrationDidSucceed: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Get started!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Text("Use your email to create an account")
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                Divider()
                ScrollView {
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
                            Text("You already have an account. Please, sign in instead.")
                                .foregroundColor(.red)
                        }
                        
                        Button(action: {
                            createNewAccount()
                        }) {
                            RegisterButtonContent()
                        }
                    }
                    .padding(.bottom, 3.0)
                    HStack{
                        Rectangle()
                            .frame(width: 50.0, height: 1.0)
                        Text("Or continue with")
                        Rectangle()
                            .frame(width: 50.0, height: 1.0)
                        
                    }
                    
                    //            Qui da mettere quello di Facebook
                    SignInWithAppleButton(
                        onRequest: { request in
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                        },
                        onCompletion: { result in
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                        }
                    )
                        .frame(width: 200.0, height: 40.0)
                        .cornerRadius(10)
                        .padding()
                    
                    HStack {
                        Text("Already registered?")
                        Text("Sign in now!")
                            .foregroundColor(Color("AccentColor"))
                        //                    .onTapGesture {
                        //                        <#code#>
                        //                    }
                    }
                    .padding()
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
                }
            }.frame(width: 400.0, height: 850.0)
        }//.navigationBarBackButtonHidden(true)
        
    }
    

    

    
    private func createNewAccount() {
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                registrationDidFail = true
                return
            }
            let userID = result?.user.uid ?? ""
            print("Successfully created user: \(userID)")
            dbManager.addUser(userID: userID, username: username, email: email)
            registrationDidSucceed = true
 
        }
    }
    
}
struct emailTextField : View {
    
    @Binding var email: String
    
    var body: some View {
        return TextField("name@example.com", text: $email)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .cornerRadius(10.0)
            .padding(.bottom, 20)
    }
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

struct ContentView_Previews6: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
