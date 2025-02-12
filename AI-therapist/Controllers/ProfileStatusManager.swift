//
//  ProfileStatusManager.swift
//  Radiant
//
//  Created by Elvina Shamoi on 23/12/24.
//


import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import _PhotosUI_SwiftUI

class ProfileStatusManager: ObservableObject {
    
    // Bool var controlling the settings popup
    @Published var isProfileSettingsPopupShowing: Bool = false
    
    // Rate limiting
    @Published var numActionsInLastMinute: Int = 0
    @Published var firstActionDate: Date?
    @Published var lastActionDate: Date?
    
    // Firestore
    let db = Firestore.firestore()
    @Published var userProfile: UserProfile?
    
    // Firebase Storage
    let storage = Storage.storage()
    // Premium User Profile Picture
    @Published var isUploadProfilePhotoPopupShowing: Bool = false
    @Published var data: Data?
    @Published var selectedItem: [PhotosPickerItem] = []
    
    // Premium User
    @Published var premiumUserProfilePicture: UIImage?
    

    func retrieveUserProfile(userID: String) {
        let docRef = db.collection(Constants.FStore.usersCollectionName).document(userID)
        
        docRef.getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let userProf):
                // A UserProfile value was successfully initalized from the DocumentSnapshot
                self.userProfile = userProf
                //                print("Successfully retrieved the user profile stored in Firestore. Access it with profileStatusManager.userProfile")
                print("user premium status: ", self.userProfile?.isPremiumUser ?? "none")
                
                // if user is premium download their profile picture and save it to the profileStateManager
                if let isPremium = self.userProfile?.isPremiumUser {
                    if isPremium {
                        if let hasPhoto = self.userProfile?.doesPremiumUserHaveCustomProfilePicture {
                            if hasPhoto {
                                // Download the photo from FB storage
                                let path = "profile_pictures/"
                                let id = self.userProfile?.id! ?? ""
                                let fullPath = path + id
                                
                                let pathReference = self.storage.reference(withPath: fullPath)

                                
                                // Download in memory with a maximum allowed size of 10MB (10 * 1024 * 1024 bytes)
                                pathReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                                  if let error = error {
                                    // Uh-oh, an error occurred!
                                      print("error downloading photo from storage")
                                      print(error.localizedDescription)
                                  } else {
                                      // Data for "images/island.jpg" is returned
                                      self.premiumUserProfilePicture = UIImage(data: data!)
                                      print("premium photo set, its accessible in profileStateManager")
                                  }
                                }
                            }
                        }
                    }
                }
                
            case .failure(let error):
                // A UserProfile value could not be initialized from the DocumentSnapshot
//                print("Failure retrieving the user profile from firestore: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func updateUserProfileEmail(newEmail: String) -> String? {
        var errorText: String?
        
        if let user = userProfile {
            // We can assume if the user exists they have an ID
            let docRef = db.collection(Constants.FStore.usersCollectionName).document(user.id!)
            
            // Before we set the new emails, make sure they are valid email addresses
            userProfile?.email = newEmail
            userProfile?.displayName = newEmail
            do {
                try docRef.setData(from: userProfile)
            } catch {
                errorText = error.localizedDescription
            }
        }
        return errorText
    }
    
    func updateUserName(newName: String) -> String? {
        var errorText: String?
        
        if let user = userProfile {
            if newName.count > 50 {
                return "name too long"
            }
            
            let docRef = db.collection(Constants.FStore.usersCollectionName).document(user.id!)
            
            userProfile?.name = newName
            do {
                try docRef.setData(from: userProfile)
            } catch {
                errorText = error.localizedDescription
            }
        }
        return errorText
    }
    
    func updateUserDisplayName(newName: String) -> String? {
        var errorText: String?
        
        if let user = userProfile {
            
            if newName.count > 50 {
                return "name too long"
            }
            
            let docRef = db.collection(Constants.FStore.usersCollectionName).document(user.id!)
            
            userProfile?.displayName = newName
            do {
                try docRef.setData(from: userProfile)
            } catch {
                errorText = error.localizedDescription
            }
        }
        return errorText
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        // Regular expression to validate email addresses
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        // Create a regular expression object
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        // Return true if the email address is valid
        return emailTest.evaluate(with: emailAddressString)
    }
    
    func processFirestoreWrite() -> String? {
        var errorText: String?
        
        // if firstAction Date Exists
        if let firstD = self.firstActionDate {
            
            let oneMinFromFirst = firstD + 60
            
            // if last action date is within one minute of first action date
            if self.lastActionDate! <= oneMinFromFirst {
                // num actions within 1 minute greater than 5
                if self.numActionsInLastMinute >= 5 {
                    errorText = "Too many actions in one minute"
                } else {
                    // num actions within one minute less than 5
                    self.lastActionDate = Date()
                    self.numActionsInLastMinute += 1
                }
            } else {
                // Last action date after 1 miute from first action date
                self.firstActionDate = Date()
                self.lastActionDate = Date()
                self.numActionsInLastMinute = 1
            }
            
        } else {
            // First action date doesn't exist
            self.firstActionDate = Date()
            self.lastActionDate = Date()
            self.numActionsInLastMinute = 1
        }
        
        return errorText
    }
    
    func uploadPremiumUserProfilePhoto(userID: String) {
        let storageRef = storage.reference()
        // points to 'profile_pictures/userID'
        let url = "profile_pictures/" + userID
        print(url)
        let imageRef = storageRef.child(url)
        
        // Add metadata for the image being uploaded
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        
        imageRef.putData(self.data!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else { return }
            
            self.retrieveUserProfile(userID: userID)
        }
        
        // Write to firestore editing user profile photo
        let docRef = db.collection(Constants.FStore.usersCollectionName).document(userID)
        
        userProfile?.doesPremiumUserHaveCustomProfilePicture = true
        do {
            try docRef.setData(from: userProfile)
        } catch {
            print(error.localizedDescription)
        }
    }
}
