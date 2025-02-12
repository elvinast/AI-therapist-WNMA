//
//  ForumPost.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/23/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ForumPost: Codable, Identifiable {
//    @DocumentID var id: String?
    var id: String?
    var authorID: String?
    var authorUsername: String?
    var authorProfilePhoto: String?
    var category: String?
    var date: Date?
    // Var used to read the date Timestamp in firestore
    var timestamp: Timestamp?
    var content: String?
    var reportCount: Int?
    var likes: [String]?
}
