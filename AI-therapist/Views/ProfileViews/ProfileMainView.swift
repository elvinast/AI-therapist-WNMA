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
    
    @State var isChangePlanPopupShowing: Bool = false
    
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
                        
                        
                        if let isPremiumUser = profileStateManager.userProfile?.isPremiumUser {
                            if !isPremiumUser {
                                Button(action: {
                                    //                            authStateManager.logOut()
                                    isChangePlanPopupShowing = true
                                }) {
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(.blue)
                                        .frame(width: 120, height: 40)
                                        .overlay {
                                            Text("Change Plan")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                        }
                                    
                                }
                                .sheet(isPresented: $isChangePlanPopupShowing) {
                                    UpgradeToPremiumPopup()
                                }
                            }
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

struct UpgradeToPremiumPopup: View {
    
    @State var isYearlySelected: Bool = true
    
    @EnvironmentObject
    private var entitlementManager: EntitlementManager

    @EnvironmentObject
    private var purchaseManager: PurchaseManager
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                
                if entitlementManager.hasPro {
                    Text("Thank you for purchasing pro! You may need to restart the app to access the premium features")
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .foregroundColor(.black)
                } else {
                    Rectangle()
                        .frame(width: 500, height: 40)
                        .foregroundColor(.blue)
                        .overlay {
                            Text("Upgrade to Premium")
                                .foregroundColor(.white)
                                .font(.system(size: 16, design: .serif))
                        }
                    
                    Text("Premium Membership")
                        .foregroundColor(.black)
                        .font(.system(size: 18, design: .serif))
                        .bold()
                        .padding(.top, 20)
                    
                    Text("Unlock full feature access and customizability")
                        .foregroundColor(.black)
                        .font(.system(size: 14, design: .serif))
                        .padding(.top, 6)
                    
                    Image("upgrade_lotus")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Group {
                        Text("Features included:")
                            .foregroundColor(.black)
                            .font(.system(size: 18, design: .serif))
                        Text("- Unlimited access to the community form")
                            .foregroundColor(.black)
                            .font(.system(size: 14, design: .serif))
                        Text("- Unlimited access to AI-therapist Chat Bot")
                            .foregroundColor(.black)
                            .font(.system(size: 14, design: .serif))
                        Text("- Full access to education pieces and activities")
                            .foregroundColor(.black)
                            .font(.system(size: 14, design: .serif))
                        Text("- Complete check-ins with photo summaries")
                            .foregroundColor(.black)
                            .font(.system(size: 14, design: .serif))
                        Text("- Express yourself with custom profile pictures")
                            .foregroundColor(.black)
                            .font(.system(size: 14, design: .serif))
                    }
                    
                    HStack {
                        if isYearlySelected {
                            Button(action: {
                                isYearlySelected = false
                            }) {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 120, height: 160)
                                //                                                .foregroundColor(.cyan)
                                    .overlay {
                                        VStack {
                                            Text("Monthly")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18, design: .serif))
                                                .padding(.top, 10)
                                            
                                            Spacer()
                                            
                                            Text("$6.99")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                            
                                            Text("per month")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                                .padding(.bottom, 10)
                                        }
                                        
                                    }
                            }
                        } else {
                            Button(action: {
                                isYearlySelected = false
                            }) {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 140, height: 180)
                                //                                                .foregroundColor(.cyan)
                                    .overlay {
                                        VStack {
                                            Text("Monthly")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18, design: .serif))
                                                .padding(.top, 10)
                                            
                                            Spacer()
                                            
                                            Text("$6.99")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                            
                                            Text("per month")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                                .padding(.bottom, 10)
                                        }
                                        
                                    }
                            }
                        }
                        
                        if isYearlySelected {
                            Button(action: {
                                isYearlySelected = true
                            }) {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 140, height: 180)
                                //                                                .foregroundColor(.cyan)
                                    .overlay {
                                        VStack {
                                            Text("Yearly")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18, design: .serif))
                                                .padding(.top, 10)
                                            
                                            Spacer()
                                            
                                            Text("$59.99")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                            
                                            Text("per year")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                                .padding(.bottom, 10)
                                            
                                            Text("Save 30%")
                                                .foregroundColor(.green)
                                                .font(.system(size: 16, design: .serif))
                                                .padding(.bottom, 10)
                                            
                                        }
                                        
                                    }
                            }
                        } else {
                            Button(action: {
                                isYearlySelected = true
                            }) {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 120, height: 160)
                                //                                                .foregroundColor(.cyan)
                                    .overlay {
                                        VStack {
                                            Text("Yearly")
                                                .foregroundColor(.black)
                                                .font(.system(size: 18, design: .serif))
                                                .padding(.top, 10)
                                            
                                            Spacer()
                                            
                                            Text("$59.99")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                            
                                            Text("per year")
                                                .foregroundColor(.black)
                                                .font(.system(size: 16, design: .serif))
                                                .padding(.bottom, 10)
                                            
                                            Text("Save 30%")
                                                .foregroundColor(.green)
                                                .font(.system(size: 16, design: .serif))
                                                .padding(.bottom, 10)
                                            
                                        }
                                        
                                    }
                            }
                        }
                        
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        print("user wanted to confim premium purchase, calling purchase function")
                        print("value of isYearly:  ", isYearlySelected)
                        Task {
                            var product: Product
                            if isYearlySelected {
                                // Hopefully this spits out yearly??
                                product = purchaseManager.products[1]
                                print("The product selected is: ", product.displayName)
                                do {
                                    try await purchaseManager.purchase(product)
                                } catch {
                                    print(error)
                                }
                            } else {
                                // Hopefully this spits out monthly??
                                product = purchaseManager.products[0]
                                print("The product selected is: ", product.displayName)
                                do {
                                    try await purchaseManager.purchase(product)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }) {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                            .foregroundColor(.blue)
                            .overlay {
                                ZStack {
                                    Text("Confirm")
                                        .foregroundColor(.white)
                                        .font(.system(size: 13, design: .serif))
                                }
                            }
                        
                        
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
        }.task {
            do {
                try await purchaseManager.loadProducts()
            } catch {
                print(error)
            }
        }
        .onAppear {
            isYearlySelected = true
        }
    }
}
