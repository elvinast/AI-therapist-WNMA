//
//  WelcomeSurveyView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 09/01/25.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct WelcomeSurveyView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @State var selectedProfilePhoto: Int = 0
    
    var body: some View {
        ZStack {
            Image("Welcome_Survey_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Text("Welcome to AI-therapist")
                    .font(.system(size: 24, design: .serif))
                    .padding(.bottom, 40)
                    .foregroundColor(.black)
                
                Text("Please answer a few questions so we can know you better")
                    .font(.system(size: 18, design: .serif))
                    .padding(.bottom, 40)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .foregroundColor(.black)
                
                ScrollView {
                    VStack {
                        // Name
                        VStack {
                            Text("What's your name?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                                .padding(.bottom, 20)
                            
                            TextField("Enter text", text: $authStateManager.name)
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 40)
                                .foregroundColor(.black)
                            //                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                                .padding(.bottom, 20)
                        }
                        
                        .padding(.bottom, 40)
                        
                        // Photo
                        VStack {
                            Text("Please select a profile photo:")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                            
                            
                            HStack {
                                // Profile Pic 1
                                Button(action: {
                                    self.selectedProfilePhoto = 0
                                }) {
                                    ZStack {
                                        Image("profile_photo_0")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                        
                                        if self.selectedProfilePhoto == 0 {
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
                                .padding(.trailing, 10)
                                // Profile Pic 2
                                Button(action: {
                                    self.selectedProfilePhoto = 1
                                }) {
                                    ZStack {
                                        Image("profile_photo_1")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                        
                                        if self.selectedProfilePhoto == 1 {
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
                            .padding(.bottom, 10)
                            
                            HStack {
                                // Profile Pic 3
                                Button(action: {
                                    self.selectedProfilePhoto = 2
                                }) {
                                    ZStack {
                                        Image("profile_photo_2")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                        
                                        if self.selectedProfilePhoto == 2 {
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
                                .padding(.trailing, 10)
                                // Profile Pic 4
                                Button(action: {
                                    self.selectedProfilePhoto = 3
                                }) {
                                    ZStack {
                                        Image("profile_photo_3")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                        
                                        if self.selectedProfilePhoto == 3 {
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
                            .padding(.bottom, 10)
                            
                            // Profile Pic 5
                            Button(action: {
                                self.selectedProfilePhoto = 4
                            }) {
                                ZStack {
                                    Image("profile_photo_4")
                                        .resizable()
                                        .frame(width:80, height: 80)
                                        .clipShape(Circle())
                                    
                                    if self.selectedProfilePhoto == 4 {
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
                        .padding(.bottom, 40)
                        
                        // Birthday
                        VStack {
                            Text("When's your birthday?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                            
                            DatePicker(selection: $authStateManager.birthday, in: ...Date(), displayedComponents: .date) {
                            }
                            .padding(.trailing, 140)
                            .padding(.bottom, 20)
                        }
                        
                        // Display Name
                        VStack {
                            Text("What's you username?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                            
                            Text("Username is used for the communty forum")
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                            
                            
                            TextField("Enter text", text: $authStateManager.displayName)
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                                .padding(.bottom, 40)
                        }
                        
                        // Aspiration
                        VStack {
                            Text("What are you looking to get out of this app? (Select all)")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                                .padding(.bottom, 20)
                            
                            Aspiration(aspirationText: "Track my mood and goals", goalHue: 1.0, goalSaturation: 0.111)
                            
                            Aspiration(aspirationText: "Learn about my mental health via educative activities and articles", goalHue: 0.797, goalSaturation: 0.111)
                            
                            Aspiration(aspirationText: "Connect with a like minded community", goalHue: 0.542, goalSaturation: 0.111)
                            
                            Aspiration(aspirationText: "Find help in my area", goalHue: 0.324, goalSaturation: 0.111)
                        }
                        .padding(.bottom, 40)
                        
                        
                        if authStateManager.isErrorInSurvey {
                            Text(authStateManager.errorText)
                                .foregroundColor(.red)
                                .font(.system(size: 20, design: .serif))
                        }
                        // Submit
                        Button(action: {
                            print("User wanted to finish their welcome survey")
                            if let user = Auth.auth().currentUser?.uid {
                                // Complete welcome survey
                                authStateManager.completeWelcomeSurvey(user: user, userPhotoSelection: self.selectedProfilePhoto)
                                // Update user profile with new info
                                //    This may not work because the completeWelcomeSurvey function is async and may take some time to update
                                profileStateManager.retrieveUserProfile(userID: user)
                            }
                        }) {
                            
                            RoundedRectangle(cornerRadius: 25)
                                .frame(maxWidth: 240, minHeight: 60)
                                .overlay {
                                    Text("Continue to AI-therapist")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, design: .serif))
                                }
                            
                        }
                        .padding(.bottom, 40)
                        
                    }
                    .padding(.bottom, 40)
                }
                .padding(.bottom, 80)
                .scrollDismissesKeyboard(.immediately)
            }
            .padding(.top, 140)
            
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
    let goalSaturation: CGFloat?
    
    @State var aspirationSelected = false
    
    var body: some View {
        Button(action: {
            print("goal complete")
            aspirationSelected = !aspirationSelected
        }) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hue: goalHue!, saturation: goalSaturation!, brightness: 1.0))
                .frame(width: 360, height: 60, alignment: .leading)
                .overlay {
                    VStack() {
                        if aspirationSelected {
                            Text(aspirationText!)
                                .foregroundColor(.green)
                                .font(.system(size: 16, design: .serif))
                        }
                        else {
                            Text(aspirationText!)
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                    
                    if aspirationSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 26, alignment: .leading)
                            .foregroundColor(.green)
                            .offset(x: 175, y: -28)
                    }
                }
        }
    }
}

