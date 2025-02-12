//
//  UserProfile.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 17/01/25.
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
    
    // Login Info
    var hasUserCompletedWelcomeSurvey: Bool?
    
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
