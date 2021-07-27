//
//  LogInView.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/27/21.
//
// Tutorial - https://www.youtube.com/watch?v=wSHnmtnzbfs

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

struct LogInView: View {
    
    @EnvironmentObject  var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Username", text: $username)
            SecureField("password", text: $password)
            Button("Log in", action: {
                sessionManager.login(
                    username: username,
                    password: password
                )
            })
            Spacer()
            Button("Don't have an account? Sign Up.", action:
                sessionManager.showSignUp)
            
        }
        .padding()
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


