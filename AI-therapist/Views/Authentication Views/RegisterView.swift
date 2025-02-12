//
//  RegisterView.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 7/01/25.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct RegisterView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    
    var body: some View {
        NavigationView() {
            ZStack {
                Image("Register_BG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    // Register with Apple button
                    SignInWithAppleButton(
                        onRequest: { request in
                            let nonce = authStateManager.randomNonceString()
                            authStateManager.currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = authStateManager.sha256(nonce)
                        },
                        onCompletion: { result in
                            authStateManager.appleSignInButtonOnCompletion(result: result)
                        }
                    ).frame(width: 350, height: 60)
                        .cornerRadius(50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2))
                }.padding(.bottom, 75)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthStatusManager())
    }
}
