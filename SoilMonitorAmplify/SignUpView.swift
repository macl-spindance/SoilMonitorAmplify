//
//  SignUpView.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/27/21.
//
//  Tutorial - https://www.youtube.com/watch?v=wSHnmtnzbfs

//
//  SignUpView.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/27/21.
//
// Tutorial - https://www.youtube.com/watch?v=wSHnmtnzbfs

import SwiftUI
import Amplify
//import AWSCognitoAuthPlugin

struct SignUpView: View {
    @EnvironmentObject  var sessionManager: SessionManager
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Username", text: $username)
            TextField("email", text: $email)
            SecureField("password", text: $password)
            Button("Sign Up", action: {
                sessionManager.signUp(
                    username: username,
                    password: password,
                    email: email
                )
            }).padding()
            
            Spacer()
            Button("Already have an account? Log in.", action: {
                sessionManager.showLogin()
            })
        }
        .padding()
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
