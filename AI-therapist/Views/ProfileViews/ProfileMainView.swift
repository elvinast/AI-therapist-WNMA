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
            Image("Profile_BG2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        authStateManager.logOut()
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.red)
                            .frame(width: 90, height: 50)
                            .overlay {
                                Text("Log Out")
                                    .foregroundColor(.black)
                                    .font(.system(size: 14, design: .serif))
                            }
                    }.padding(.leading, 20)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        profileStateManager.isProfileSettingsPopupShowing = true
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }.sheet(isPresented: $profileStateManager.isProfileSettingsPopupShowing) {
                        ProfileSettingsView()
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                HStack {
                    
                    // Non premium
                    if let isPremiumUser = profileStateManager.userProfile?.isPremiumUser {
                        if !isPremiumUser {
                            if let profPic = profileStateManager.userProfile?.userPhotoNonPremium {
                                Image(profPic)
                                    .resizable()
                                    .frame(width: 80, height: 80, alignment: .leading)
                                    .clipShape(Circle())
                                    .padding(.trailing, 10)
                            }
                        } else {
                            if let hasPremiumPhoto = profileStateManager.userProfile?.doesPremiumUserHaveCustomProfilePicture {
                                if hasPremiumPhoto {
                                    if let image = profileStateManager.premiumUserProfilePicture {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .leading)
                                            .clipShape(Circle())
                                            .padding(.trailing, 10)
                                            .overlay(alignment: .topTrailing) {
                                                // upload user premium button
                                                Button(action: {
                                                    profileStateManager.isUploadProfilePhotoPopupShowing = true
                                                }) {
                                                    Image(systemName: "pencil.circle.fill")
                                                        .symbolRenderingMode(.multicolor)
                                                        .font(.system(size: 30))
                                                        .foregroundColor(.accentColor)
                                                }.sheet(isPresented: $profileStateManager.isUploadProfilePhotoPopupShowing) {
                                                    UploadProfilePhotoPopup()
                                                }
                                            }
                                    }
                                } else {
                                    if let profPic = profileStateManager.userProfile?.userPhotoNonPremium {
                                        Image(profPic)
                                            .resizable()
                                            .frame(width: 80, height: 80, alignment: .leading)
                                            .clipShape(Circle())
                                            .padding(.trailing, 10)
                                            .overlay(alignment: .topTrailing) {
                                                // upload user premium button
                                                Button(action: {
                                                    profileStateManager.isUploadProfilePhotoPopupShowing = true
                                                }) {
                                                    Image(systemName: "pencil.circle.fill")
                                                        .symbolRenderingMode(.multicolor)
                                                        .font(.system(size: 30))
                                                        .foregroundColor(.accentColor)
                                                }.sheet(isPresented: $profileStateManager.isUploadProfilePhotoPopupShowing) {
                                                    UploadProfilePhotoPopup()
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                    
                    if let name = profileStateManager.userProfile?.name {
                        Text(name)
                            .foregroundColor(.white)
                            .font(.system(size: 20, design: .serif))
                            .padding(.leading, 20)
                    } else {
                        Text("User")
                            .padding(.trailing, 30)
                            .foregroundColor(.white)
                            .font(.system(size: 20, design: .serif))
                            .padding(.leading, 20)
                    }
                }
                .padding(.bottom, 20)
                
                VStack {
                    if let displayName = profileStateManager.userProfile?.displayName {
                        Text(displayName)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    } else {
                        Text("Display Name")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    }
                }
                .padding(.bottom, 40)
                
                VStack {
                    if let email = profileStateManager.userProfile?.email {
                        Text(email)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    } else {
                        Text("placeholder@email.com")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    }
                }
                .padding(.bottom, 40)
                
                
                VStack {
                    
                    HStack {
                        Text("Current Plan")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 20, design: .serif))
                        
                        
                        if let isPremium = profileStateManager.userProfile?.isPremiumUser {
                            if isPremium {
                                Text("Premium")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, design: .serif))
                            } else {
                                Text("Basic")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, design: .serif))
                            }
                        } else {
                            Text("Basic")
                                .foregroundColor(.white)
                                .font(.system(size: 18, design: .serif))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.bottom, 20)
                }
                
                
                Spacer()
            }.padding(.top, 75)
            
            
            
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
