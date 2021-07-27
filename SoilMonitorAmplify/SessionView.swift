//
//  SessionView.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/27/21.
//

import SwiftUI
import Amplify

struct SessionView: View {
    
    @EnvironmentObject  var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        VStack{
            Spacer()
            Text("You signed in as \(user.username)!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Sign Out", action: sessionManager.signOut)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        SessionView(user: DummyUser())
    }
}
