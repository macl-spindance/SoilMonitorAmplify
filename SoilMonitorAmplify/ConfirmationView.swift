//
//  ConfirmationView.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/27/21.
//
//  Tutorial - https://www.youtube.com/watch?v=wSHnmtnzbfs

import SwiftUI
import Amplify
//import AWSCognitoAuthPlugin

struct ConfirmationView: View {
    
    @EnvironmentObject  var sessionManager: SessionManager
    @State var confirmationCode = ""

    var username: String
    
    var body: some View {
        VStack {
            Text("Username: \(username)")
            TextField("Confirmation Code", text: $confirmationCode)
            Button("Confirm", action: {
                sessionManager.confirm(
                    username: username,
                    code: confirmationCode
                )
            })
        }
        .padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "dummy")
    }
}
