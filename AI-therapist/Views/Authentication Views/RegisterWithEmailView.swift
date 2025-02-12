//
//  RegisterWithEmailPopupView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/3/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct RegisterWithEmailView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    
    var body: some View {
        
        ZStack {
            // Background Image
            Image("Register_Email_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Close popup Button
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .offset(x: 170, y: -300)
                    .onTapGesture {
                        // Dismiss the register with email popup on tap
                        authStateManager.isRegisterPopupShowing = false
                    }
                    .padding(.top, 30)
                
                VStack {
                    // Label
                    Text("Register with your email")
                        .padding(.bottom, 400)
                        .font(.system(size: 30, design: .serif))
                        .foregroundColor(.white)
                    
                    VStack {
                        // Email text field
                        TextField("Email", text: $authStateManager.email)
                            .foregroundColor(Color.white)
                            .padding(.leading, 20)
                            .cornerRadius(50)
                            .frame(maxWidth: 300, minHeight: 40)
                            .font(.system(size: 25, design: .default))
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding(.bottom, 15)
                        
                        // Password text fields
                        SecureField("Password", text: $authStateManager.password)
                            .foregroundColor(Color.white)
                            .padding(.leading, 20)
                            .cornerRadius(50)
                            .frame(maxWidth: 300, minHeight: 40)
                            .font(.system(size: 25, design: .default))
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding(.bottom, 15)
                        
                        // Register Button
                        Button(action: {
                            print("From popup View: The Register button on regist with email popup was pressed")
                            authStateManager.registerWithEmail()
                            print("Testing async order")
                        }) {
                            Text("Register").foregroundColor(.white).font(.system(size: 20)).underline()
                        }
                    }
                    .padding(.bottom, 200)
                }.offset(y: 80)
                
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
}


struct RegisterWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterWithEmailView()
            .environmentObject(AuthStatusManager())
        
    }
}
