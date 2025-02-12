//
//  ProfileSettingsView.swift
//  Radiant
//
//  Created by Elvina Shamoi on 02/02/25.
//


// TODO: CONSIDER CREATING ONLY ONE PRESENT_EDIT ALERT, AND PASS IN THE DATA BEING CHANGED AS AN ARGUMENT EACH TIME TO ALTER THE ALERT SHOWN

import SwiftUI
import FirebaseAuth
import StoreKit

struct ProfileSettingsView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @State private var presentEditPhotoAlert = false
    
//    @State private var presentEditEmailAlert = false
//    @State private var oldEmail = ""
//    @State private var newEmail = ""
    
    @State private var presentEditNameAlert = false
    @State private var newName = ""
    @State private var presentEditDisplayNameAlert = false
    @State private var newDisplayName = ""
    
    @State private var presentDeleteAccountAlert = false
    
    // Toggles for community forum
    // anon toggle
    // filter profanity toggle
    
    @State private var errorText = ""
    @State private var presentErrorAlert = false
    
    var body: some View {
        ZStack {
            Image("Profile_BG2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                List {
                    HStack(alignment: .center) {
                        
                        ZStack {
                            // Profile Photo
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
                                
                        }
                    }
                    
                    Section(header: Text("Radiant")) {
                        Link("Terms of Use (EULA)", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                        
                        
                        Link("Privacy Policy", destination: URL(string: "https://sites.google.com/view/radiant-privacy-policy/home")!)
                    }
                    
                    Section(header: Text("Account Details")) {
                        // Email
                        HStack {
                            Text("Email: ")
                                .bold()
                            if let email = profileStateManager.userProfile?.email {
                                Text("\(email)")
                            } else {
                                Text("TestEmail@google.com")
                            }
                        }
                        
                        // Birthday
                        HStack {
                            Text("Birthday: ")
                                .bold()
                            if let bday = profileStateManager.userProfile?.birthday {
                                Text(bday, style: .date)
                            } else {
                                Text(Date.now, style: .date)
                            }
                        }
                        
                        // Name
                        HStack {
                            Text("Name: ")
                                .bold()
                            if let name = profileStateManager.userProfile?.name {
                                Text(name)
                            } else {
                                Text("User")
                            }
                            
                            Button(action: {
                                // Rate limiting check
                                if let rateLimit = profileStateManager.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    presentEditNameAlert = true
                                    print("User wanted to change name")
                                }
                            })
                            {
                                Image(systemName: "info.circle")
                            }
                            .alert("Edit Name", isPresented: $presentEditNameAlert) {
                                TextField("New Name", text: $newName)
                                HStack {
                                    Button("Cancel", role: .cancel) {
                                        presentEditNameAlert = false
                                    }.foregroundColor(.red)
                                    Button("Save", role: .none) {
                                        
                                        if newName != "" {
                                            if let err = profileStateManager.updateUserName(newName: newName) {
                                                print("error changing name: \(err)")
                                            } else {
                                                print("name change success")
                                            }
                                        }
                                        presentEditNameAlert = false
                                    }.foregroundColor(.blue)
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    Section(header: Text("Community Forum")) {
                        // Display Name
                        HStack {
                            Text("Display Name: ")
                                .bold()
                            if let displayName = profileStateManager.userProfile?.displayName {
                                Text(displayName)
                            } else {
                                Text("User")
                            }
                            
                            Button(action: {
                                // Rate limiting check
                                if let rateLimit = profileStateManager.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    presentEditDisplayNameAlert = true
                                    print("User wanted to change display name")
                                }
                            })
                            {
                                Image(systemName: "info.circle")
                            }
                            .alert("Edit Dispaly Name", isPresented: $presentEditDisplayNameAlert) {
                                TextField("New Dispaly Name", text: $newDisplayName)
                                HStack {
                                    Button("Cancel", role: .cancel) {
                                        presentEditDisplayNameAlert = false
                                    }.foregroundColor(.red)
                                    Button("Save", role: .none) {
                                        
                                        if newDisplayName != "" {
                                            if let err = profileStateManager.updateUserDisplayName(newName: newDisplayName) {
                                                print("error changing name: \(err)")
                                            } else {
                                                print("name change success")
                                            }
                                        }
                                        presentEditDisplayNameAlert = false
                                    }.foregroundColor(.blue)
                                }
                                
                            }
                        }
                        
//                        Toggle(isOn: $profileStateManager.isForumAnon, label: {
//                            Text("Appear anonymous on the forum")
//                        })
//                        Toggle(isOn: $profileStateManager.isProfanityFiltered, label: {
//                            Text("Filter profanity")
//                        })
                    }
                    
                    Section(header: Text("Account")) {
                        Button {
                            Task {
                                do {
                                    try await AppStore.sync()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                        }
                        Button(action: {
                            // Sign out of account
                            authStateManager.logOut()
                        }) {
                            Text("Sign Out")
                        }
                        Button(action: {
                            // Sign out of account
//                            authStateManager.logOut()
                            print("delete account")
                            self.presentDeleteAccountAlert = true
                        }) {
                            Text("Delete Account")
                                .foregroundColor(.red)
                        }
                        .alert("Are you sure you want to delete your account?", isPresented: self.$presentDeleteAccountAlert) {
                            Button(action: {
                                print("cancel")
                                self.presentDeleteAccountAlert = false
                            }) {
                                Text("No")
                            }
                            Button(action: {
                                if let user = Auth.auth().currentUser?.uid {
                                    print("current auth user is: ", user)
                                    print("current profile manager user is: ", profileStateManager.userProfile?.id ?? "no id on userProfile")
                                    authStateManager.deleteAccount(userID: user)
                                } else {
                                    print("trying to delete from profile settings view, but now Auth user was found")
                                }
                            }) {
                                Text("Yes")
                            }
                        }
                    }
                    
                }
            }
        }.padding(.top, 100)
        
        
    }
}


struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}
