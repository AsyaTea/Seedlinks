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
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSucceed: Bool = false
    
    @State var editingMode: Bool = false
    
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
            VStack {
                UsernameTextField(username: $username, editingMode: $editingMode)
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
                    UIApplication.shared.endEditing()
                    if self.username == storedUsername && self.password == storedPassword {
                        self.authenticationDidSucceed = true
                        self.authenticationDidFail = false
                    } else {
                        self.authenticationDidFail = true
                    }
                }) {
                    LoginButtonContent()
                }
            }
            //        .offset(y: editingMode ? -150 : 0)
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
//                    .onTapGesture {
//                        <#code#>
//                    }
            }
        }
        .frame(width: 400.0, height: 600.0)
        
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
    
    @Binding var editingMode: Bool
    
    var body: some View {
        return TextField("Username", text: $username, onEditingChanged: {edit in
            if edit == true
            {self.editingMode = true}
            else
            {self.editingMode = false}
        })
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
            .padding(.bottom, 20)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

struct AppleIdButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
}

struct ContentView_Previews5: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
