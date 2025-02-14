//
//  ProfileMainView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 02/02/25.
//

import SwiftUI
import _PhotosUI_SwiftUI
import StoreKit

struct ProfileMainView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        ZStack {
            // Background Gradient with a slight radial focus
            LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("GentleGold").opacity(0.8)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Top Navigation
                HStack {
                    Button(action: {
                        authStateManager.logOut()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.circle.fill")
                                .foregroundColor(Color.secondary)
                                .font(.title2)
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(Color.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        profileStateManager.isProfileSettingsPopupShowing = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(Color.secondary)
                    }
                    .sheet(isPresented: $profileStateManager.isProfileSettingsPopupShowing) {
                        ProfileSettingsView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Profile Card
                VStack(spacing: 8) {
                    if let profPic = profileStateManager.userProfile?.userPhotoNonPremium {
                        Image(profPic)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 3))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 110, height: 110)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    if let name = profileStateManager.userProfile?.name {
                        Text(name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    } else {
                        Text("User")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                    
                    if let displayName = profileStateManager.userProfile?.displayName {
                        Text(displayName)
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    } else {
                        Text("Display Name")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                    }
                    
                    if let email = profileStateManager.userProfile?.email {
                        Text(email)
                            .font(.footnote)
                            .foregroundColor(Color.white)
                    } else {
                        Text("placeholder@email.com")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .shadow(radius: 3)
                .padding(.horizontal, 20)
                
                // Separator
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 40)
                
                // Mood Section
                VStack(spacing: 10) {
                    Text("Today's Mood 🌿")
                        .font(.headline)
                        .foregroundColor(Color.secondary)
                    
                    Text("Feeling calm and balanced.")
                        .font(.subheadline)
                        .foregroundColor(Color.secondary)
                        .italic()
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}


struct UploadProfilePhotoPopup: View {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        Form {
            Section {
                PhotosPicker(selection: $profileStateManager.selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                    if let data = profileStateManager.data, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame( maxHeight: 300)
                    } else {
                        Label("Select a picture", systemImage: "photo.on.rectangle.angled")
                    }
                }.onChange(of: profileStateManager.selectedItem) { newValue in
                    guard let item = profileStateManager.selectedItem.first else {
                        return
                    }
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                profileStateManager.data = data
                            }
                        case .failure(let failure):
                            print("Error: \(failure.localizedDescription)")
                        }
                    }
                }
            }
            Section {
                Button("Confirm") {
                    // Function to post data to Firebase Storage
                    if let user = profileStateManager.userProfile {
                        profileStateManager.uploadPremiumUserProfilePhoto(userID: user.id!)
                        profileStateManager.isUploadProfilePhotoPopupShowing = false
                    }
                }.disabled(profileStateManager.data == nil)
            }
        }
    }
}
