//
//  Login-View.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import SwiftUI
import AuthenticationServices


let storedUsername = "Username"
let storedPassword = "Password"


struct LoginView: View {
    
    @ObservedObject var userSession : UserSession
    
    var body: some View {
        NavigationView {

            SignInView(userSession: userSession)
        }
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("Sign in")
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
        return TextField("Username", text: $username)
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .cornerRadius(10.0)
            .padding(.bottom, 20)
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    
    var body: some View {
        return SecureField("Password", text: $password)
            .padding()
            .cornerRadius(10.0)
    }
}



struct AppleIdButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
}
struct SignInView: View {
    

    @ObservedObject var userSession : UserSession
    @State var email: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Text("You have been missed")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
            Divider()
            ScrollView {
                VStack {
                    emailTextField(email: $email)
                    PasswordSecureField(password: $password)
                    if authenticationDidFail {
                        Text("Information not correct. Try again.")
                            .offset(y: -10)
                            .foregroundColor(.red)
                    }
                    Text("Forgotten password?")
                        .fontWeight(.thin)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 390, height: 30, alignment: .trailing)
                        .onTapGesture {
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
                HStack{
                    Rectangle()
                        .frame(width: 50.0, height: 1.0)
                    Text("Or continue with")
                    Rectangle()
                        .frame(width: 50.0, height: 1.0)
                    
                }
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
                //            Qui da mettere quello di Google
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
                
                HStack{
                    Text("Not a member?")
                    Text("Register now!")
                        .foregroundColor(Color("AccentColor"))
                    //                    .onTapGesture {
                    //                        <#code#>
                    //                    }
                }
            }
            
        } .frame(width: 400.0, height: 800.0)
        
    }
    
    
    
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
            
        }
    }
}

//struct ContentView_Previews5: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
