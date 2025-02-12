//
//  HistoryManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/12/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class HistoryManager: ObservableObject {
    @Published var focusedDay: Day?
    
    @Published var days: [Day] = []
    @Published var userCheckIns: [String : CheckIn] = [:]
    @Published var checkInPremiumPhotos: [String : UIImage] = [:]
    
    // Firebase Firestore
    let db = Firestore.firestore()
    
    // Firebase Storage
    let storage = Storage.storage()
    
    init(){
        // Generate a Day object for each day from today to 3 months ago
        let today = Date()
        let threeMonthsAgo = Date() - 7776000
        var curDay = threeMonthsAgo
        while (curDay <= today) {
            
            var newDay = Day(dayOfMonth: -1, month: "", formattedDateForFirestore: "")
            
            // Get the day of the month as an int
            let components = Calendar.current.dateComponents([.day], from: curDay)
            newDay.dayOfMonth = components.day!
            
            // Get the month as a string
            newDay.month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: curDay) - 1]
            
            // Format the current date
            newDay.formattedDateForFirestore = curDay.formatted(date: .abbreviated, time: .omitted)
            
            // append a new Day object to the Days array
            self.days.append(newDay)
            
            curDay += 86400
        }
        self.focusedDay = self.days[self.days.count-1]
    }
    
    func crossCheckDaysWithCheckInsFromFirstore(userId: String) {
        
        // Read each checkIn with the user's ID attatched
        //   Add the check-In to the map of {date: checkIn}
        //     Read each of the days from the [days] array of the last 3 months
        //        if there exists a check-in for that day in the {date: checkin} map, attatch the checkIn to the Day() object, which can be accessed from the view
        
        // Get the user's checkIns from firebase and store them in the usercheckIns map
        db.collection("checkIns").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    //                    print("Error getting user's checkins: ", err.localizedDescription)
                } else {
                    for document in querySnapshot!.documents {
                        let date = document.data()["date"] as? String
                        let goals = document.data()["goals"] as? [String]
                        let gratitude = document.data()["gratitude"] as? String
                        let happinessScore = document.data()["happinessScore"] as? Double
                        let depressionScore = document.data()["depressionScore"] as? Double
                        let anxietyScore = document.data()["anxietyScore"] as? Double
                        let journalEntry = document.data()["journalEntry"] as? String
                        let isPremiumCheckInPhoto = document.data()["isPremiumCheckInPhoto"] as? Bool
                        let checkIn = CheckIn(userId: userId, date: date, goals: goals, gratitude: gratitude, happinessScore: happinessScore, depressionScore: depressionScore, anxietyScore: anxietyScore, journalEntry: journalEntry, isPremiumCheckInPhoto: isPremiumCheckInPhoto)
                        self.userCheckIns[date!] = checkIn
                    }
                    
                    // Read each of the days in the days array and attatch the check-in if it exists
                    for var i in 0...self.days.count - 1 {
                        if let daysCheckIn = self.userCheckIns[self.days[i].formattedDateForFirestore] {
                            self.days[i].doesCheckInExist = true
                            self.days[i].checkIn = daysCheckIn
                            // If check-in exists, look for a premium photo
                            if let isPhoto = self.days[i].checkIn!.isPremiumCheckInPhoto {
                                if isPhoto {
                                    self.days[i].doesCheckInPhotoExist = true
                                }
                            }

                        } else {
                            self.days[i].doesCheckInExist = false
                            //                            print("day doesn't exist for ", self.days[i].formattedDateForFirestore)
                        }
                        i += 1
                    }
                    self.focusedDay = self.days[self.days.count-1]
                    // Check for premium check in photos, store them in a separate map
                    self.attatchPremiumCheckInPhotos(userId: userId)
                }
            }
    }
    
    func attatchPremiumCheckInPhotos(userId: String) {
        for i in 0...self.days.count - 1 {
            if self.days[i].doesCheckInExist {
                if self.days[i].doesCheckInPhotoExist {
                    // If the checkIn has a respective photo, download it and store it in the Day : UIImage Map
                    let path = "checkin_photos/"
                    let id = userId
                    let fullPath = path + id + self.days[i].formattedDateForFirestore
                    print(fullPath)
                    
                    let pathReference = self.storage.reference(withPath: fullPath)
                    
                    // Download in memory with a maximum allowed size of 7MB (10 * 1024 * 1024 bytes)
                    pathReference.getData(maxSize: 7 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print("error downloading photo from storage")
                            print(error.localizedDescription)
                        } else {
                            // Data for "images/island.jpg" is returned
                            self.checkInPremiumPhotos[self.days[i].formattedDateForFirestore] = UIImage(data: data!)
//                            print("checkin photo set, its accessible in the checkInManager.checkInPremiumPhotos")
                        }
                    }
                }
            }
        }
    }
}


class Day: Identifiable, Equatable {
    static func == (lhs: Day, rhs: Day) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    // Variables populated during generateDays()
    var id = UUID()
    var dayOfMonth: Int
    var month: String
    var formattedDateForFirestore: String
    
    // Variables populated during crossCheckDaysFromFirestore()
    var doesCheckInExist: Bool = false
    var checkIn: CheckIn?
    // Premium CheckIn Photo
    @Published var doesCheckInPhotoExist: Bool = false
    @Published var checkInPremiumPhoto: UIImage = UIImage()
    
    init(dayOfMonth: Int, month: String, formattedDateForFirestore: String) {
        self.dayOfMonth = dayOfMonth
        self.month = month
        self.formattedDateForFirestore = formattedDateForFirestore
    }
}


