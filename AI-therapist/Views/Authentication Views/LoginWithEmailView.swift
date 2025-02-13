//
//  LoginView.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 5/01/25.
//

import SwiftUI

struct LoginWithEmailView: View {
    @EnvironmentObject var authStateManager: AuthStatusManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("SoftCoral"), Color("GentleGold")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Close Button
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 30))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Title & Description
                Text("Login with your email")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // Input Fields
                VStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .frame(maxWidth: 320, alignment: .leading)
                    .padding(.horizontal, 20)

                    TextField("Enter your email", text: $authStateManager.email)
                        .padding()
                        .frame(width: 320, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .frame(maxWidth: 320, alignment: .leading)
                    .padding(.horizontal, 20)

                    SecureField("Enter your password", text: $authStateManager.password)
                        .padding()
                        .frame(width: 320, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    // Login Button
                    Button(action: {
                        authStateManager.loginWithEmail { error in
                            if let error {
                                self.showAlert = true
                            }
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("SoftCoral"))
                            .frame(width: 320, height: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Email or passowrd is wrong. Try again."), dismissButton: .default(Text("OK")))
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

struct LoginWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginWithEmailView()
            .environmentObject(AuthStatusManager())
    }
}
