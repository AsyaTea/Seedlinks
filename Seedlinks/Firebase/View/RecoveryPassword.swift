//
//  RecoveryPassword.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 23/02/22.
//

import SwiftUI

struct RecoveryPassword: View {
    
    @ObservedObject var userSession : UserSession
    @State var email = ""
    
    var body: some View {
        VStack{
            Text("Please insert your email")
            emailTextField(email: $email)
            Button(action: {
                userSession.passwordReset(email:email)
            }, label: {
                Text("Send reset password")
            })
        }
    }
}
//
//struct RecoveryPassword_Previews: PreviewProvider {
//    static var previews: some View {
//        RecoveryPassword()
//    }
//}
