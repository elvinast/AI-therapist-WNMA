//
//  HomeManager.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 12/01/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeManager: ObservableObject {
    
    @Published var isCheckInPopupShowing: Bool = false
    
    @Published var hasUserCheckedInToday: Bool = false
    @Published var lastCheckInDate: String = ""
    @Published var userFirstName: String = "User"
    @Published var userProfilePhoto: String = "default_prof_pic"
    
    
    @Published var todaysCheckIn: CheckIn? = CheckIn(userId: nil, date: "", goals: ["Please check-in to set your goals", "", ""], gratitude: "I'm grateful for you, user!", happinessScore: -1, depressionScore: -1, anxietyScore: -1, journalEntry: "")
    
    
    @Published var quoteOfTheDay: String = ""
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    // TODO(bendreyer): We're doing this read of the signed in userProfile twice, once here and once in the profileStatus manager. We can consolidate.
    let userProfile: UserProfile? = nil
    
    
    // initiate variables in the HomeManager on appear
    func userInit(userID: String) {
        // Get the day of the month for the quote of the day
        let day = Calendar.current.component(.day, from: Date())
//        print("day of the month: \(day)")
        let quoteRef = db.collection("quotes").document("\(day)")
        quoteRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.quoteOfTheDay = document.data()!["quote"] as! String
            } else {
//                print("Quote of the day does exist")
            }
        }
        
        let userDocRef = db.collection("users").document(userID)
        
        // Todo: Understand why we're doing this in homeManager?
        userDocRef.getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let user):
//                print("we sucessfully got the user in homeManager")
                print("user id: ", user.id!)
                if let name = user.name {
                    self.userFirstName = name
                }
                
                self.userProfilePhoto = user.userPhotoNonPremium ?? "default_prof_pic"
                

                let today = Date().formatted(date: .abbreviated, time: .omitted)
                
                if let lastCheckInDate = user.lastCheckinDate {
                    self.lastCheckInDate = lastCheckInDate
                }
                
                // Set has user checked in today boolean
                if today == user.lastCheckinDate {
                    self.hasUserCheckedInToday = true
//                    print("user has already checked in today")
                } else {
                    self.hasUserCheckedInToday = false
//                    print("user has not checked in today")
                }
            case .failure(let error):
//                print("error getting the user in the home manger: ", error.localizedDescription)
                break
            }
        }
        
        // Get today's checkIn Data
        db.collection("checkIns").whereField("userId", isEqualTo: userID).whereField("date", isEqualTo: Date().formatted(date: .abbreviated, time: .omitted))
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
//                    print("error retrievign user's checkins: ", err.localizedDescription)
                } else {
//                    print("retrieved checkins sucessfully!")
                    for document in querySnapshot!.documents {
                        
                        let userId = document.data()["userId"] as? String
                        let date = document.data()["date"] as? String
                        let goals = document.data()["goals"] as? [String]
                        let gratitude = document.data()["gratitude"] as? String
                        let happinessScore = document.data()["happinessScore"] as? Double
                        let depressionScore = document.data()["depressionScore"] as? Double
                        let anxietyScore = document.data()["anxietyScore"] as? Double
                        let journalEntry = document.data()["journalEntry"] as? String
                        let newCheckIn: CheckIn = CheckIn(userId: userId, date: date, goals: goals, gratitude: gratitude, happinessScore: happinessScore, depressionScore: depressionScore, anxietyScore: anxietyScore, journalEntry: journalEntry)
                        self.todaysCheckIn = newCheckIn
                    }
//                    print(self.todaysCheckIn)
                }
            }
    }
}
