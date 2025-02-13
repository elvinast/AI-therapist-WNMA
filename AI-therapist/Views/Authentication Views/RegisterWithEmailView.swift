//
//  RegisterWithEmailPopupView.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 11/01/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct RegisterWithEmailView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("SoftCoral"), Color("GentleGold")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
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
                
                Text("Register with your email")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                TextField("Email", text: $authStateManager.email)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )

                SecureField("Password", text: $authStateManager.password)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )

                Button(action: {
                    authStateManager.registerWithEmail()
                }) {
                    Text("Register")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(Color("SoftCoral"))
                        .frame(width: 320, height: 50)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.top, 40)
            
//            if let errorMessage = authStateManager.authErrorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .font(.subheadline)
//                    .multilineTextAlignment(.center)
//                    .padding()
//            }

        }
        .scrollDismissesKeyboard(.immediately)
    }
}

struct RegisterWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterWithEmailView()
            .environmentObject(AuthStatusManager())
    }
}
