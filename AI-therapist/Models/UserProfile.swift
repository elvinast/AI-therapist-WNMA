//
//  UserProfile.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/7/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI


struct UserProfile: Codable {
    @DocumentID var id: String?
    var email: String?
    var name: String?
    var displayName: String?
    var birthday: Date?
    var weight: Int?
    var height: Double?
    var userPhotoNonPremium: String?
    
    var lastCheckinDate: String?
//    var checkIns: [CheckIn]?
    
    // Login Info
    var hasUserCompletedWelcomeSurvey: Bool?
//    var hasUserEnteredBetaCode: Bool?
    
    // Premium Features
    var isPremiumUser: Bool?
    var doesPremiumUserHaveCustomProfilePicture: Bool?
    // Community Forum
    var lastForumPostDate: Date?
    var numPostsToday: Int?
    var lastForumCommentDate: Date?
    var numCommentsToday: Int?
    // Chat
    var lastMessageSendDate: Date?
    var numMessagesSentToday: Int?
}
