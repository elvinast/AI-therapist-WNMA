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
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("SoftCoral"), Color("GentleGold")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    Image("ai_therapist_illustration")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                    
                    VStack(spacing: 8) {
                        Text("Welcome to AI Therapist")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("A supportive and intelligent space to help you on your journey to well-being.")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                    }
                    
                    Spacer()
                    
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
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .cornerRadius(15)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    
                    // OR Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.5))
                        Text("OR")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.caption)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 20)
                    
                    NavigationLink(destination: RegisterWithEmailView()) {
                        Text("Sign up with Email")
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("SoftCoral"))
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal, 16)
                    }
                    
                    NavigationLink(destination: LoginWithEmailView().environmentObject(authStateManager)) {
                        Text("Already have an account? Log in")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                            .underline()
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
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
