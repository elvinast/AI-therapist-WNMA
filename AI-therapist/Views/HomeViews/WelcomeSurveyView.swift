//
//  WelcomeSurveyView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 09/01/25.
//

import SwiftUI
import FirebaseAuth

struct WelcomeSurveyView: View {
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @State var selectedProfilePhoto: Int = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("SoftCoral"), Color("GentleGold")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome to AI-therapist")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Please answer a few questions so we can know you better")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 320, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("What's your name?")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                        .frame(maxWidth: 320, alignment: .leading)
                        .padding(.horizontal, 20)

                        TextField("Enter your name", text: $authStateManager.name)
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
                            Text("Please select a profile photo:")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                        .frame(maxWidth: 320, alignment: .leading)
                        .padding(.horizontal, 20)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(0..<4, id: \.self) { index in
                                Button(action: {
                                    self.selectedProfilePhoto = index
                                }) {
                                    ZStack {
                                        Image("profile_photo_\(index)")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                        
                                        if self.selectedProfilePhoto == index {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(Color.green)
                                                .offset(x: 25, y: -25)
                                            
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.black)
                                                .offset(x: 25, y: -25)
                                        }
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("What's your username?")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                            
                            Text("Username is used for the community forum")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 16))
                        }
                        .frame(maxWidth: 320, alignment: .leading)
                        .padding(.horizontal, 20)

                        TextField("Enter username", text: $authStateManager.displayName)
                            .padding()
                            .frame(width: 320, height: 50)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 12) {
                            Text("What are you looking to get out of this app?")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                        .frame(maxWidth: 320, alignment: .leading)
                        .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            Aspiration(aspirationText: "Track my mood and goals", goalHue: 1.0)
                            Aspiration(aspirationText: "Learn about my mental health", goalHue: 0.797)
                            Aspiration(aspirationText: "Connect with a like-minded people", goalHue: 0.542)
                            Aspiration(aspirationText: "Find help in my area", goalHue: 0.324)
                        }

                        Button(action: {
                            print("User wanted to finish their welcome survey")
                            if let user = Auth.auth().currentUser?.uid {
                                // Complete welcome survey
                                authStateManager.completeWelcomeSurvey(user: user, userPhotoSelection: self.selectedProfilePhoto)
                                // Update user profile with new info
                                //    This may not work because the completeWelcomeSurvey function is async and may take some time to update
                                profileStateManager.retrieveUserProfile(userID: user)
//                            if let user = Auth.auth().currentUser?.uid {
//                                authStateManager.completeWelcomeSurvey(user: user, userPhotoSelection: self.selectedProfilePhoto)
//                                profileStateManager.retrieveUserProfile(userID: user)
                            }
                        }) {
                            Text("Continue to AI-therapist")
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
                .padding(.top, 10)
            }
            .padding(.top, 20)
        }
    }
}

struct WelcomeSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSurveyView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}

struct Aspiration : View {
    let aspirationText: String?
    let goalHue: CGFloat?

    @State var aspirationSelected = false
    
    var body: some View {
        Button(action: {
            aspirationSelected.toggle()
        }) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(aspirationSelected ? Color.green.opacity(0.7) : Color.white.opacity(0.2))
                .frame(width: 320, height: 50)
                .overlay {
                    HStack {
                        Text(aspirationText!)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.leading, 15)
                        
                        Spacer()
                        
                        if aspirationSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.green)
                                .padding(.trailing, 15)
                        }
                    }
                }
                .animation(.easeInOut, value: aspirationSelected)
        }
    }
}
