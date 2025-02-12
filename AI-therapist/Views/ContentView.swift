//
//  ContentView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct ContentView: View {
    
    @StateObject var authStateManager = AuthStatusManager()
    @StateObject var profileStateManager = ProfileStatusManager()
    
    @State var test: Bool = false
    
    var body: some View {
        
        ZStack {
            // Show the WelcomeView or Register View depending on user login status stored in userDefaults
            if let loginStatus = UserDefaults.standard.object(forKey: loginStatusKey) as? Bool {
                
                
                // Show the register / login screen either if the loginStatus is nil, or false
                if loginStatus == false {
                    RegisterView()
                }
                
                
                // Main App Flow
                if loginStatus == true {
                    WelcomeView()
                    // Retrieve the UserProfile from firestore and store it in authStateManager.userProfile
                        .onAppear {
                            if let userID = Auth.auth().currentUser?.uid {
                                // This function is async, and code below it will not function properly if relying on authStateManager.userProfile
                                profileStateManager.retrieveUserProfile(userID: userID)
                            } else {
                                print("The current user could not be retrieved")
                                authStateManager.logOut()
                            }
                        }
                    
                    
                    // Welcome Survey flow
                    // if this is user's first time signing into the app, show Welcome Survey
                    
                    if let hasUserCompletedWelcomeSurvey = UserDefaults.standard.object(forKey: hasUserCompletedWelcomeSurveyKey) as? Bool {
                        if hasUserCompletedWelcomeSurvey == false {
                            WelcomeSurveyView()
                        }
                    }
                    
                    // this might be too slow
//                    if let hasUserCompletedWelcomeSurvey = profileStateManager.userProfile?.hasUserCompletedWelcomeSurvey {
//                        if hasUserCompletedWelcomeSurvey == false {
//                            WelcomeSurveyView()
//                        }
//                    } else {
//                        Text("Too slow")
//                    }
                    
//                    if let userProf = profileStateManager.userProfile {
//                        if let has = userProf.hasUserCompletedWelcomeSurvey {
//                            if has == false {
//                                WelcomeSurveyView()
//                            }
//                        }
//                    }
                } else {
//                    RegisterView()
                }
            } else {
                Text("No user default set")
            }
        }
        .environmentObject(authStateManager)
        .environmentObject(profileStateManager)
        .onAppear {
            print("User default welcome survey: \(UserDefaults.standard.object(forKey: hasUserCompletedWelcomeSurveyKey) ?? "no key")")
            
            print("User default beta status: \(UserDefaults.standard.object(forKey: isUserValidForBetaKey) ?? "no key" )")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
