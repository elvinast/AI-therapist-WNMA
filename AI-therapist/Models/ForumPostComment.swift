//
//  ForumPostComment.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/23/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ForumPostComment: Codable, Identifiable {
//    @DocumentID var id: String?
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
    
    // Var will never be stored in firebase, only used when translating back from firebase -> swift
    var isCommentLikedByCurrentUser: Bool?
}
