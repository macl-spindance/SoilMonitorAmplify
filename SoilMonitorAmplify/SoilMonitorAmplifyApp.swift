//
//  SoilMonitorAmplifyApp.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/26/21.
//
//  Tutorial - https://www.youtube.com/watch?v=wSHnmtnzbfs

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct SoilMonitorAmplifyApp: App {
    //this is the older UIKit way of configuring things at initialization
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @ObservedObject var sessionManager = SessionManager()
    
    init() {
        configureAmplify()
       // sessionManager.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LogInView()
                    .environmentObject(sessionManager)
                
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
                
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
                
            case .session(let user):
                SessionView(user: user)
                    .environmentObject(sessionManager)
                
            }
        }
    }
    
    private func configureAmplify() {

        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }

    }
}
