//
//  LoginAppleID.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import Foundation
import AuthenticationServices


class LoginAppleId: NSObject, ASAuthorizationControllerDelegate {
    func getAppleRequest () {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
    }
    struct UserModel: Codable {
        let name: String?
        let email: String?
    }
    
    class ViewModel: ObservableObject {
        private var login = LoginAppleId()
        @Published var user: UserModel?
        
        func appleLogin () {
            login.getAppleRequest()
        }
        
        func getUserInfo() {
            guard let userData = UserDefaults.standard.object(forKey: "userEncoded") as? Data else { return }
            guard let userEncoded = try? JSONDecoder().decode(UserModel.self, from: userData) else { return }
            self.user = userEncoded
        }
        
    }
    
    func getUserInfo(fullName: String, email: String) {
        let user = UserModel(name: fullName, email: email)
        if let userEncoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userEncoded, forKey: "userEncoded")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let name = credentials.fullName?.givenName else { return }
        guard let surname = credentials.fullName?.familyName else { return }
        let fullName = "\(name) \(surname)"
        guard let email = credentials.email else { return }
        getUserInfo(fullName: fullName, email: email)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error in your login with AppleId", error.localizedDescription)
    }
}
