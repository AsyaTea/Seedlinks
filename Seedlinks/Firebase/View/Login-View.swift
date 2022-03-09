//
//  Login-View.swift
//  Seedlinks
//
//  Created by Asya Tealdi on 17/02/22.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth


let failedToLog: String = "Failed to login user!"
let successfulLog: String = "Successfully logged in as user: "

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
    @State var errorString : String = ""
    @State var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
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
                if userSession.authenticationDidFail {
                    Text(errorString)
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                
                NavigationLink(destination: RecoveryPassword(userSession: userSession)){
                    Text("Forgotten password?")
                        .fontWeight(.thin)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 390, height: 30, alignment: .trailing)
                }
            }
            
            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                userSession.loginUser(email: email, password: password)
                userSession.sendSignInEmail(email: email)
                
            }) {
                LoginButtonContent()
            }
            .padding()
            if userSession.authenticationDidSucceed {
                Text("Login succeeded!")
                    .font(.headline)
                    .frame(width: 250, height: 80)
                    .background(Color.green)
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .animation(Animation.linear(duration: 1), value: 1.5)
            }
//            SignInWithAppleButton(
//                onRequest: { request in
//                    let nonce = randomNonceString()
//                    currentNonce = nonce
//                    request.requestedScopes = [.fullName, .email]
//                    request.nonce = sha256(nonce)
//            }, onCompletion: { result in
//                switch result {
//                    case .success(let authResults):
//                        switch authResults.credential {
//                        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//                            guard let nonce = currentNonce else {
//                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                            }
//                            guard let appleIDToken = appleIDCredential.identityToken else {
//                                fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                            }
//                            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                                return
//                            }
//
//                            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
//                            Auth.auth().signIn(with: credential) { (authResult, error) in
//                                if (error != nil) {
//                                    print(error?.localizedDescription as Any)
//                                    return
//                                }
//                                print("signed in")
//                                self.userSession.loginUser(email: email, password: password)
//                            }
//
//                            print("\(String(describing: Auth.auth().currentUser?.uid))")
//                        default:
//                            break
//                        }
//                    default:
//                        break
//                                    }
//            }
//                )
                

            HStack{
                Text("Not a member?")
                    .font(.footnote)
                NavigationLink(destination: RegisterView(userSession: userSession)) {
                    Text("Register now!")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                }
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

//struct ContentView_Previews5: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
