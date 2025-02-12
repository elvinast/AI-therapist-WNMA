//
//  CheckInManager.swift
//  Radiant
//
//  Created by Viiktoria Voevodina on 17/01/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import _PhotosUI_SwiftUI


class CheckInManager: ObservableObject {
    @Published var happinessSliderVal: Double = 5.0
    @Published var depressionSliderVal: Double = 5.0
    @Published var anxeitySliderVal: Double = 5.0
    
    @Published var goalOne: String = ""
    @Published var goalTwo: String = ""
    @Published var goalThree: String = ""
    
    @Published var gratitude: String = ""
    
    @Published var journalEntry: String = ""
    
    @Published var isErrorInCheckIn: Bool = false
    @Published var errorText: String = ""
    
    // Firebase Storage
    let storage = Storage.storage()
    
    // Premium CheckIn Picture
    @Published var isUploadCheckInPhotoShowing: Bool = false
    @Published var data: Data?
    @Published var selectedItem: [PhotosPickerItem] = []
    
    let db = Firestore.firestore()
    
    func checkIn(userID: String) {
        
//        print("user wanted to check in and send the goals, user: \(userID)")
        
        if goalOne == "" && goalTwo == "" && goalThree == "" {
            self.isErrorInCheckIn = true
            self.errorText = "Please enter at least one goal"
            return
        }
        
        if gratitude == "" {
            self.isErrorInCheckIn = true
            self.errorText = "Please enter something you are grateful for"
            return
        } else {
            self.isErrorInCheckIn = false
            self.errorText = ""
        }
        
        if goalOne.count > 300 || goalTwo.count > 300 || goalThree.count > 300 || gratitude.count > 300 || journalEntry.count > 600 {
            self.isErrorInCheckIn = true
            self.errorText = "Please limit the length of your responses, they are too long"
            return
        }
        
        let userDocumentRef = db.collection("users").document(userID)
        
        let date = Date()
        let formattedDate = date.formatted(date: .abbreviated, time: .omitted)
        
        userDocumentRef.updateData([
            "lastCheckinDate": formattedDate,
        ]) { err in
            if let err = err {
//                print("Error updating document: \(err)")
            } else {
//                print("Document successfully updated")
            }
        }
        
        // Check for premium check-in photo
        var isPremiumPhoto: Bool = false
        if self.data != nil {
            isPremiumPhoto = true
            self.uploadPremiumCheckInPhoto(userID: userID)
        }
        
        let checkInsRef = db.collection("checkIns")
        checkInsRef.addDocument(data: [
            "userId": userID,
            "date": formattedDate,
            "goals": [self.goalOne, self.goalTwo, self.goalThree],
            "gratitude": self.gratitude,
            "happinessScore": self.happinessSliderVal,
            "depressionScore": self.depressionSliderVal,
            "anxietyScore": self.anxeitySliderVal,
            "journalEntry": self.journalEntry,
            "isPremiumCheckInPhoto": isPremiumPhoto
        ]) { err in
            if let err = err {
//                print("Error adding checkin: \(err.localizedDescription)")
            } else {
//                print("Check in added successfully")
            }
        }
    }
    
    func uploadPremiumCheckInPhoto(userID: String) {
        let storageRef = storage.reference()
        // points to 'profile_pictures/userIDDate'
        let date = Date().formatted(date: .abbreviated, time: .omitted)
        let url = "checkin_photos/" + userID + date.description
        print(url)
        let imageRef = storageRef.child(url)
        
        // Add metadata for the image being uploaded
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        imageRef.putData(self.data!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else { return }
        }
        
        // Write to firestore editing user profile photo
//        let docRef = db.collection(Constants.FStore.usersCollectionName).document(userID)
//
//        userProfile?.doesPremiumUserHaveCustomProfilePicture = true
//        do {
//            try docRef.setData(from: userProfile)
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}


