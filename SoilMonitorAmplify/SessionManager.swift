//
//  AmplifyAuth.swift
//  SoilMonitorAmplify
//
//  Created by Mac Lobdell on 7/26/21.
//
//  Tutorial - https://www.youtube.com/watch?v=wSHnmtnzbfs

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

//Tutorial - https://docs.amplify.aws/lib/auth/getting-started/q/platform/ios

//TODO - after logging in, how do you get session credentials to access AWS IoT?
//I think you follow the same method of getting the client ID. But instead of a hard coded Identity Pool ID, need to get that from Amplify?

//TODO - need to update new authenticated IAM role policy to have access to connect to AWS IoT and subscribe to specific topics

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
 
    func getCurrentAuthUser(){
        if let user = Amplify.Auth.getCurrentUser(){
            authState = .session(user: user)
        }else {
            authState = .login
        }
    }
    
    func showSignUp(){
        authState = .signUp
    }
    
    func showLogin(){
        authState = .login
    }
    
    func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
       
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { [weak self] result in

            switch result {
                
            case .success(let signUpResult):
                print("sign up result:", signUpResult)
                
                switch signUpResult.nextStep {
                
                case .done:
                    print("Finished sign up")
                
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                }
                
            case .failure(let error):
                print("sign up error",error)
            
            }
        }
    }
     
    func confirm(username: String, code: String) {
        
        _ = Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: code
        ){ [weak self] result in
         
            switch result {
            
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete{
                    DispatchQueue.main.async{
                        self?.showLogin()
                    }
                }

            case .failure(let error):
                print("failed to confirm code:",error)
            }
        }
    }
    
    func login(username: String, password: String) {
        
        _ = Amplify.Auth.signIn(
            username: username,
            password: password
        ){ [weak self] result in
            
            switch result {
            
            case .success(let signInResult):
                print(signInResult)
                if signInResult.isSignedIn{
                    DispatchQueue.main.async{
                        self?.getCurrentAuthUser()
                    }
                }

            case .failure(let error):
                print("Log in:",error)
            }
            
        }
    }
    
    func signOut() {
        
        _ = Amplify.Auth.signOut() {
            [weak self] result in
                
                switch result {
                
                case .success:
                    DispatchQueue.main.async{
                        self?.getCurrentAuthUser()
                    }

                case .failure(let error):
                    print("Sign out error",error)
                }
    
        }

    }
}


/*
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }

        return true
    }
}
*/
/*
func fetchCurrentAuthSession() -> AnyCancellable {
    Amplify.Auth.fetchAuthSession().resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Fetch session failed with error \(authError)")
            }
        }
        receiveValue: { session in
            print("Is user signed in - \(session.isSignedIn)")
        }
}

//Register a user
func signUp(username: String, password: String, email: String) -> AnyCancellable {
    let userAttributes = [AuthUserAttribute(.email, value: email)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    let sink = Amplify.Auth.signUp(username: username, password: password, options: options)
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("An error occurred while registering a user \(authError)")
            }
        }
        receiveValue: { signUpResult in
            if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails))")
            } else {
                print("SignUp Complete")
            }

        }
    return sink
}

//confirm sign up with confirmation code received in email

func confirmSignUp(for username: String, with confirmationCode: String) -> AnyCancellable {
    Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("An error occurred while confirming sign up \(authError)")
            }
        }
        receiveValue: { _ in
            print("Confirm signUp succeeded")
        }
}

//Sign In a User

func signIn(username: String, password: String) -> AnyCancellable {
    Amplify.Auth.signIn(username: username, password: password)
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Sign in failed \(authError)")
            }
        }
        receiveValue: { _ in
            print("Sign in succeeded")
        }
}

//Fetch current users attributes

func fetchAttributes() -> AnyCancellable {
    Amplify.Auth.fetchUserAttributes()
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Fetch user attributes failed with error \(authError)")
            }
        }
        receiveValue: { attributes in
            print("User attributes - \(attributes)")
        }
}

//Update (or create?) a user attribute

func updateAttribute() -> AnyCancellable {
    Amplify.Auth.update(userAttribute: AuthUserAttribute(.phoneNumber, value: "+2223334444"))
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Update attribute failed with error \(authError)")
            }
        }
        receiveValue: { updateResult in
            switch updateResult.nextStep {
            case .confirmAttributeWithCode(let deliveryDetails, let info):
                print("Confirm the attribute with details send to - \(deliveryDetails) \(info)")
            case .done:
                print("Update completed")
            }
        }
}

//verify a user attribute

func confirmAttribute() -> AnyCancellable {
    Amplify.Auth.confirm(userAttribute: .email, confirmationCode: "390739")
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Update attribute failed with error \(authError)")
            }
        }
        receiveValue: { _ in
            print("Attribute verified")
        }
}

//Resend verification code

func resendCode() -> AnyCancellable {
    Amplify.Auth.resendConfirmationCode(for: .email)
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Resend code failed with error \(authError)")
            }
        }
        receiveValue: { deliveryDetails in
            print("Resend code sent to - \(deliveryDetails)")
        }
}

//signout

func signOutLocally() -> AnyCancellable {
    Amplify.Auth.signOut()
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Sign out failed with error \(authError)")
            }
        }
        receiveValue: {
            print("Successfully signed out")
        }
}

*/
