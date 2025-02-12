//
//  WelcomeView.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 27/12/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct WelcomeView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        ZStack {
            VStack {
                BottomNavBar()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}

