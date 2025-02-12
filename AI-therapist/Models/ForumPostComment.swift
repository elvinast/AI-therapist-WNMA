//
//  ForumPostComment.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 01/02/25.
//

import Foundation
import FirebaseFirestoreSwift

struct ForumPostComment: Codable, Identifiable {
    var id: String?
    var postID: String?
    var parentCommentID: String?
    var authorID: String?
    var authorUsername: String?
    var authorProfilePhoto: String?
    var date: Date?
    var commentCategory: String?
    var content: String?
    var likes: [String]?
    var reportCount: Int?
    
    var isCommentLikedByCurrentUser: Bool?
}
