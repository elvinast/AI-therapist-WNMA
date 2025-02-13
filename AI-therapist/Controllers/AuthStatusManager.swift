//
//  AuthStatusManager.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 20/12/24.
//

import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI


class AuthStatusManager: ObservableObject {
    // This variable tracks whether or not the user will encounter the login / register screens
    @Published var isLoggedIn: Bool = false
    
    // These vars are used for registering / logging in the user with email and password
    @Published var email = ""
    @Published var password = ""
    
    // Error handling
    @Published var authErrorMessage: String? // Stores errors for UI feedback
    
    // Variables used for the closed beta
    @Published var betaCode = ""
    @Published var isBetaCodeValid: Bool = false
    @Published var betaErrorText: String?
    
    // Variables used for the welcome survey
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var displayName: String = ""
    @Published var userPhotoNonPremium: String = ""
    @Published var hasUserCompletedSurvey: Bool = false
    @Published var isErrorInSurvey = false
    @Published var errorText: String = ""
    
    
    // These vars are used for controlling the Auth popups
    @Published var isRegisterPopupShowing: Bool = false
    @Published var isLoginPopupShowing: Bool = false
    
    // Unhashed nonce. (used for Apple sign in)
    @Published var currentNonce:String?
    
    // Firestore
    let db = Firestore.firestore()
    
    // Firebase Storage
    let storage = Storage.storage()
    
    //    @Published var userProfile: UserProfile?
    
    
    // Log the user in with email and password
    func loginWithEmail(completion: @escaping (String?) -> Void) {
//        print("The user logged in with email and password")
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error {
                completion(e.localizedDescription)
                print("Issue when trying to login: \(e.localizedDescription)")
            }
            
            guard let strongSelf = self else {
                return
            }
            
            guard let user = authResult?.user else {
//                print("No user")
                return
            }
            
            
//            print("User was logged in as user, \(user.uid), with email: \(user.email ?? "no email")")
            
            strongSelf.isLoggedIn = true
            strongSelf.isLoginPopupShowing = false
            UserDefaults.standard.set(strongSelf.email, forKey: emailKey)
            UserDefaults.standard.set(strongSelf.isLoggedIn, forKey: loginStatusKey)
            
            // Retrieved the user profile from Firestore and store it in this class' userProfile var
            //            if let userID = Auth.auth().currentUser?.uid {
            //                strongSelf.retrieveUserProfile(userID: userID)
            //            } else {
            //                print("The current user could not be retrieved")
            ////                authStateManager.logOut()
            //            }
        }
    }
    
    func registerWithEmail() {
        guard !email.isEmpty, !password.isEmpty else {
            authErrorMessage = "Email and password cannot be empty."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.authErrorMessage = error.localizedDescription
                }
                print("❌ Registration Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                DispatchQueue.main.async {
                    self.authErrorMessage = "Failed to retrieve user data."
                }
                print("❌ No user returned after registration.")
                return
            }

            print("✅ User registered: \(user.uid) with email: \(user.email ?? "No Email")")

            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.isRegisterPopupShowing = false
                self.authErrorMessage = nil
                UserDefaults.standard.set(self.isLoggedIn, forKey: loginStatusKey)
            }
        }
    }

    
    // The function called in the onComplete closure of the SignInWithAppleButton in the RegisterView
    func appleSignInButtonOnCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    guard let user = authResult?.user else {
//                        print("No user")
                        return
                    }
                    
//                    print("signed in with apple")
//                    print("\(String(describing: user.uid))")
                    // Careful about saving the email into UserDefaults because the user may choose to hide email address from the app with sign in
                    if let email = user.email {
                        self.email = email
                        UserDefaults.standard.set(self.email, forKey: emailKey)
                    }
                    self.isLoggedIn = true
                    self.isRegisterPopupShowing = false
                    UserDefaults.standard.set(self.isLoggedIn, forKey: loginStatusKey)
                    
                    
                    // Figure out if the user already has an account or is signing up for the first time
                    let docRef = self.db.collection(Constants.FStore.usersCollectionName).whereField("email", isEqualTo: self.email)
                    
                    docRef.getDocuments { (querySnapshot, err) in
                        if let err = err {
//                            print("Error getting documents: \(err)")
                        } else {
                            if querySnapshot!.documents.isEmpty {
                                // New user is signing in
                                UserDefaults.standard.set(false, forKey: isUserValidForBetaKey)
                                
                                // Set the user default for the user completing the welcome survey to false, they will complete it after register
//                                print("setting the user default for the welcome survey as false")
                                UserDefaults.standard.set(false, forKey: hasUserCompletedWelcomeSurveyKey)
                                
                                // Create the user profile in Firestore
                                let userProf = UserProfile(email: self.email, displayName: self.email)
                                let collectionRef = self.db.collection(Constants.FStore.usersCollectionName)
                                do {
                                    try collectionRef.document(user.uid).setData(from: userProf)
//                                    print("Apple sign in user stored with new user reference: \(user.uid)")
                                } catch {
//                                    print("Error saving user to firestore: \(error.localizedDescription)")
                                }
                            } else {
                                // Existing user is signing in
//                                print("Existing user signing in with Apple")
                                // the userID is available in querySnapshot.documents[0].documentID
                                print("A current user with that same email already exists: ")
                                print(querySnapshot!.documents[0].documentID)
                                
                                print("But did the Auth set the userID to something different?")
                                if let user = Auth.auth().currentUser {
                                    print(user.uid)
                                }
                                
                                // Create a new userProfile with a document ID equal to the to current Auth value
                                
                            }
                        }
                    }
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    // Update a user's email address stored in the auth table (as long as they didn't sign in with apple)
    // We don't need to pass in a the newEmail as a argument, because the changing email is tied to the text field on the edit email popup
    func updateAuthEmail(newEmail: String) -> String? {
        var returnError: String?
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: newEmail) { error in
                if let e = error {
                    // TEMPORARY FIX: WHEN THE USER IS REQUIRED TO REAUTHENTICATE BY FIREBASE, SIMPLY JUST LOG THEM OUT. IN THE FUTURE, WE NEED TO ASK FOR THEIR LOGIN CREDENTIALS AGAIN AND REAUTHENTICATE BEFORE THEY CAN CHANGE THEIR EMAIL
//                    print("There was an error updating the user's email: \(e.localizedDescription)")
                    returnError = e.localizedDescription
                    
                    //                    self.logOut()
                } else {
//                    print("Successfully updated user email in the auth table, no error.")
                    self.email = newEmail
//                    print("Email updated on authStateManager: \(self.email)")
                }
            }
        }
        if returnError != nil {
            return returnError
        } else {
            return nil
        }
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
//            print("Error signing out: \(signOutError.localizedDescription)")
            return
        }
        self.isLoggedIn = false
        UserDefaults.standard.set(isLoggedIn, forKey: loginStatusKey)
    }
    
    
    // Functions for apple sign in flow
    
    // Generate a random Nonce used to make sure the ID token you get was granted specifically in response to your app's authentication request.
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // from https://firebase.google.com/docs/auth/ios/apple
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func addBetaCodes() {
        let codes = [""]
        
        // Add the beta codes to firebase
        for code in codes {
            print("adding beta code \(code) to firebase")
            db.collection("betaCodes").document(code).setData([
                "code": code,
                "isCodeUsed": false,
            ]) { err in
                if let err = err {
                    print("Error adding code: \(err)")
                } else {
                    print("Beta code successfully written!")
                }
            }
        }
    }
    
    // Check if a user's beta code is valid, allowing them to continue to the app
    func checkBetaCode(code: String, user: String) {
        
        //check if code is empty
        if code == "" {
            self.betaErrorText = "Code cannot be empty"
            return
        }
        // check if the code exists in the db
        let docRef = db.collection("betaCodes").document(code)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                
                if let isCodeUsed = document.data()!["isCodeUsed"] as? Bool {
                    if isCodeUsed == false {
                        self.isBetaCodeValid = true
                        UserDefaults.standard.set(self.isBetaCodeValid, forKey: isUserValidForBetaKey)
                        
                        // Mark the beta code as being used
                        docRef.setData([
                            "code": code,
                            "isCodeUsed": true,
                            "usedBy": user,
                        ])
                        
                    } else {
//                        print("Beta code has already been used")
                        
                        if let usedBy = document.data()!["usedBy"] as? String {
                            if usedBy == user {
                                self.isBetaCodeValid = true
                                UserDefaults.standard.set(self.isBetaCodeValid, forKey: isUserValidForBetaKey)
                            } else {
                                self.betaErrorText = "Code has been used by another user"
                            }
                        }
                    }
                }
                
            } else {
                self.betaErrorText = "Beta code is invalid"
            }
        }
    }
    
    func uploadUserProfilePicture(userID: String, image: UIImage) {
        let storageRef = storage.reference().child("profile_pictures/\(userID).png")
        
        let data = image.pngData()
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error.localizedDescription)
                }
                
                if let metadata = metadata {
                    print("Metadata: ", metadata)
                }
            }
        }
    }
    
    // Complete the welcome survey
    func completeWelcomeSurvey(user: String, userPhotoSelection: Int) {
        // First check if the text fields are empty
        if self.name == "" {
            self.isErrorInSurvey = true
            self.errorText = "Please enter a name"
            return
        }
        
        // First check if the text fields are empty
        if self.displayName == "" {
            self.isErrorInSurvey = true
            self.errorText = "Please enter a username"
            return
        }
        
        
        switch userPhotoSelection {
            case 0: self.userPhotoNonPremium = "profile_photo_0"
            case 1: self.userPhotoNonPremium = "profile_photo_1"
            case 2: self.userPhotoNonPremium = "profile_photo_2"
            case 3: self.userPhotoNonPremium = "profile_photo_3"
            case 4: self.userPhotoNonPremium = "profile_photo_4"
            default: self.userPhotoNonPremium = "profile_photo_0"
        }
        
        // update the user's firestore document with name, birthday, displayName and aspirations
        db.collection("users").document(user).updateData([
            "name": self.name,
            "birthday": self.birthday,
            "displayName": self.displayName,
            "userPhotoNonPremium": self.userPhotoNonPremium,
            "hasUserCompletedWelcomeSurvey": true,
            "isPremiumUser": false,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            } else {
                print("Data successfully saved in firebase!")
                // Set user default for completing the welcome survey to true
                self.hasUserCompletedSurvey = true
                UserDefaults.standard.set(self.hasUserCompletedSurvey, forKey: hasUserCompletedWelcomeSurveyKey)
            }
        }
    }
    
    func deleteAccount(userID: String) {
        print("deleting user: ", userID)
        // Delete the firestore user

        // Remove check ins with user id
        var checkIns: [String] = []
        db.collection("checkIns").whereField("userId", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        checkIns.append(document.documentID)
                    }
                    print("checkIns: ", checkIns)
                    // Delete checkIns
                    for checkInId in checkIns {
                        self.db.collection("checkIns").document(checkInId).delete() { err in
                            if let err = err {
                                print("Error removing checkin: \(err)")
                            } else {
                                print("CheckIn successfully removed!")
                            }
                        }
                    }
                }
        }
        // Remove forum posts
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameGeneral, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameDepression, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameStressAnxiety, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameRelationships, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameRecovery, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameAddiction, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameSobriety, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNamePersonalStories, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.forumCollectionNameAdvice, userID: userID)

        // Remove forum comments
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameGeneral, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameDepression, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameStressAnxiety, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameRelationships, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameRecovery, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameAddiction, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameSobriety, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNamePersonalStories, userID: userID)
        deleteForumPostsAndComments(collectionName: Constants.FStore.commentsCollectionNameAdvice, userID: userID)


        // remove messages
        var messages: [String] = []
        db.collection("messages").whereField("userID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    messages.append(document.documentID)
                }
                print("messages: ", messages)
                // Delete messages
                for messageID in messages {
                    self.db.collection("messages").document(messageID).delete() { err in
                        if let err = err {
                            print("Error removing message: \(err)")
                        } else {
                            print("Message successfully removed!")
                        }
                        
                    }
                }
            }
        }
        self.isBetaCodeValid = false
        UserDefaults.standard.set(self.isBetaCodeValid, forKey: isUserValidForBetaKey)

        self.hasUserCompletedSurvey = false
        UserDefaults.standard.set(self.hasUserCompletedSurvey, forKey: hasUserCompletedWelcomeSurveyKey)
        
        // Wait a few seconds for the other documents to be deleted
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.db.collection("users").document(userID).delete() { err in
                if let err = err {
                    print("Error removing user from firestore: \(err)")
                } else {
                    print("Firestore user successfully removed!")
                    // Delete Auth user
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                        if let error = error {
                            print("Error deleting auth user: ,", error)
                        } else {
                            print("Auth user got removed yay, now logging out")
                            self.logOut()
                        }
                    }
                }
            }
        }
    }
    
    func deleteForumPostsAndComments(collectionName: String, userID: String) {
        var objects: [String] = []
        db.collection(collectionName).whereField("authorID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    objects.append(document.documentID)
                }
                print("forum: ", objects)
                // Delete objects
                for object in objects {
                    self.db.collection(collectionName).document(object).delete() { err in
                        if let err = err {
                            print("Error removing forum object: \(err)")
                        } else {
                            print("Forum object successfully removed!")
                        }
                        
                    }
                }
            }
        }
    }
    
}
