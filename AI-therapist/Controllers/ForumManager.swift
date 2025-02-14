//
//  ForumManager.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 13/01/25.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ForumManager: ObservableObject {
        
    @Published var isCreatePostPopupShowing: Bool = false
    @Published var isCreateCommentPopupShowing: Bool = false
    
    @Published var isReportPostAlertShowing: Bool = false
    @Published var isReportCommentAlertShowing: Bool = false
    @Published var isDeletePostPopupAlertShowing: Bool = false
    @Published var isDeleteCommentPopupAlertShowing: Bool = false
    
    // Firestore database
    let db = Firestore.firestore()
    
    @Published var focusedPostID: String = ""
    @Published var focusedPostCategoryName: String = ""
    @Published var isFocusedPostLikedByCurrentUser: Bool = false
    
    @Published var focusedCommentID: String = ""
    
    @Published var isErrorCreatingPost: Bool = false
    @Published var isErrorCreatingComment: Bool = false
    @Published var errorText: String = ""

    // TODO: Find a way to limit the number of posts loaded, and load more when the user scrolls down
    @Published var lastDoc: QueryDocumentSnapshot?
    @Published var lastComment: QueryDocumentSnapshot?
    
    @Published var lastPostMyPosts: QueryDocumentSnapshot?
    @Published var lastCommentMyComments: QueryDocumentSnapshot?
    @Published var lastPostLikedPosts: QueryDocumentSnapshot?
    
    func publishPost(authorID: String, authorUsername: String, authorProfilePhoto: String, category: String, content: String, isPremiumUser: Bool?, lastPostDate: Date?, numPostsToday: Int?) -> Bool {
//        print("User wanted to publish a post")
//
//        print("The post length is: \(content.count)")
        
        // Free user post number check
        var newNumPostsToday: Int = 0
        if let lastPostDate = lastPostDate {
            // Get current date
            let currentDate = Date()
            // Check if last post date is less than 24 hours ago (posted today)
            if lastPostDate > (currentDate - 86400) {
                if let numPostsToday = numPostsToday {
                    newNumPostsToday = numPostsToday
                }
            } else {
                newNumPostsToday = 0
            }
        }
        // Free user hasn't reached post quota. Write to their userProfile. Don't write for premium users
        db.collection("users").document(authorID).updateData([
            "lastForumPostDate": Date(),
            "numPostsToday": newNumPostsToday + 1
        ]) { err in
            if let err = err {
                print("Error updating user forum fields: \(err)")
            } else {
                print("User forum fields updated successfully written!")
            }
        }
        
        
        if content == "" {
            self.isErrorCreatingPost = true
            self.errorText = "Please enter your post content"
            return false
        }
        
        if content.count > 300 {
            self.isErrorCreatingPost = true
            self.errorText = "Your post is too long, please shorten your post"
            return false
        } else {
            self.isErrorCreatingPost = false
            self.errorText = ""
        }
        
        // Create the Post Object and save it to the corresponding firestore collection
        let post = ForumPost(authorID: authorID, authorUsername: authorUsername, authorProfilePhoto: authorProfilePhoto, category: category, date: Date.now, content: content, reportCount: 0, likes: [authorID])
        // TODO: Add if let category = post.category to make sure the post has a corresponding cateogry to post to
        
        let collectionName = getFstoreForumCategoryCollectionName(category: category)
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: post)
//            print("Adding document was successful, documentID: \(ref!.documentID)")
            isCreatePostPopupShowing = false
        } catch {
//            print("error adding post to collection")
        }
        return true
    }
    
    func deletePost(postID: String, postCategory: String, commentList: [ForumPostComment]) {
//        print("user wanted to delete their post")
        let collectionName = getFstoreForumCategoryCollectionName(category: postCategory)
        
        // Delete post
        db.collection(collectionName).document(postID).delete() { err in
            if let err = err {
//                print("Error removing document: \(err.localizedDescription)")
            } else {
//                print("Post successfully deleted!")
            }
        }
        
        // Delete associated comments
        for comment in commentList {
            let commentCollectionName = getFstoreForumCommentsCategoryCollectionName(category: postCategory)
            db.collection(commentCollectionName).document(comment.id!).delete() { err in
                if let err = err {
//                    print("error deleting comment: \(err.localizedDescription)")
                } else {
//                    print("successfully deleted comment")
                }
            }
        }
    }
    
    func likePost(postID: String, postCategory: String, userID: String) {
        
//        print("User: \(userID) wanted to like a post: \(postID)")
        
        let collectionName = getFstoreForumCategoryCollectionName(category: postCategory)
        let documentRef = db.collection(collectionName).document(postID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayUnion([userID])
        ]) { err in
            if let err = err {
//                print("error liking the post: \(err.localizedDescription)")
            } else {
//                print("user sucessfully liked the post")
            }
        }
    }
    
    func removeLikeFromPost(postID: String, postCategory: String, userID: String) {
//        print("user wanted to remove their like from the post")
        
        let collectionName = getFstoreForumCategoryCollectionName(category: postCategory)
        let documentRef = db.collection(collectionName).document(postID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
//                print("error liking the post: \(err.localizedDescription)")
            } else {
//                print("user sucessfully liked the post")
            }
        }
    }
    
    func publishComment(authorID: String, authorUsername: String, authorProfilePhoto: String, category: String, postID: String, content: String, isPremiumUser: Bool?, lastCommentDate: Date?, numCommentsToday: Int?) -> Bool {
//        print("User wanted to publish a comment on a post")
        
        // Free user comment count check
        var newNumCommentsToday: Int = 0
        if let premium = isPremiumUser {
            if premium == false {
                if let lastCommentDate = lastCommentDate {
                    // Get current date
                    let currentDate = Date()
                    // Check if last post date is less than 24 hours ago (posted today)
                    if lastCommentDate > (currentDate - 86400) {
                        if let numCommentsToday = numCommentsToday {
                            if numCommentsToday >= 3 {
                                self.isErrorCreatingComment = true
                                self.errorText = "You've exceeded your max number of comments for today. Upgrade to premium for unlimited posts."
                                return false
                            } else {
                                newNumCommentsToday = numCommentsToday
                            }
                        }
                    } else {
                        newNumCommentsToday = 0
                    }
                }
                // Free user hasn't reached post quota. Write to their userProfile. Don't write for premium users
                db.collection("users").document(authorID).updateData([
                    "lastForumCommentDate": Date(),
                    "numCommentsToday": newNumCommentsToday + 1
                ]) { err in
                    if let err = err {
                        print("Error updating user forum fields: \(err)")
                    } else {
                        print("User forum fields updated successfully written!")
                    }
                }
            }
        }
        
        
        if content == "" {
            self.isErrorCreatingComment = true
            self.errorText = "Please enter your comment"
            return false
        }
        
        if content.count > 300 {
            self.isErrorCreatingComment = true
            self.errorText = "Your comment is too long, please shorten it"
            return false
        } else {
            self.isErrorCreatingComment = false
            self.errorText = ""
        }
        
        let comment = ForumPostComment(postID: postID, authorID: authorID, authorUsername: authorUsername, authorProfilePhoto: authorProfilePhoto, date: Date.now, commentCategory: category, content: content, likes: [authorID], reportCount: 0, isCommentLikedByCurrentUser: nil)
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: category)
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: comment)
            print("Adding comment was successful, commentID: \(ref!.documentID) saved on postID: \(postID)")
        } catch {
            print("Error adding comment to the post")
        }
        return true
    }
    
    func deleteComment(commentID: String, commentCategory: String, authorID: String) {
//        print("user wanted to delete their comment")
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: commentCategory)
        
        // Delete post
        db.collection(collectionName).document(commentID).delete() { err in
            if let err = err {
//                print("Error removing comment: \(err.localizedDescription)")
            } else {
//                print("Comment successfully deleted!")
            }
        }
    }
    
    func likeComment(commentID: String, commentCategory: String, userID: String) {
//        print("User: \(userID) wanted to like a comment: \(commentID)")
        
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: commentCategory)
        let documentRef = db.collection(collectionName).document(commentID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayUnion([userID])
        ]) { err in
            if let err = err {
//                print("error liking the post: \(err.localizedDescription)")
            } else {
//                print("user sucessfully liked the post")
            }
        }
    }
    
    func removeLikeFromComment(commentID: String, commentCategory: String, userID: String) {
//        print("user wanted to remove their like from the comment")
        
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: commentCategory)
        let documentRef = db.collection(collectionName).document(commentID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
//                print("error liking the post: \(err.localizedDescription)")
            } else {
//                print("user sucessfully liked the post")
            }
        }
    }
    
    // Get the constant name of each FStore forum collection
    func getFstoreForumCommentsCategoryCollectionName(category: String) -> String {
        
        var categoryName: String
        
        switch category {
        case "General":
            categoryName = Constants.FStore.commentsCollectionNameGeneral
        case "Depression":
            categoryName = Constants.FStore.commentsCollectionNameDepression
        case "Stress and Anxiety":
            categoryName = Constants.FStore.commentsCollectionNameStressAnxiety
        case "Relationships":
            categoryName = Constants.FStore.commentsCollectionNameRelationships
        case "Recovery":
            categoryName = Constants.FStore.commentsCollectionNameRecovery
        case "Addiction":
            categoryName = Constants.FStore.commentsCollectionNameAddiction
        case "Sobriety":
            categoryName = Constants.FStore.commentsCollectionNameSobriety
        case "Personal Stories":
            categoryName = Constants.FStore.commentsCollectionNamePersonalStories
        case "Advice":
            categoryName = Constants.FStore.commentsCollectionNameAdvice
        default:
            categoryName = Constants.FStore.commentsCollectionNameGeneral
        }
        
        return categoryName
    }
    
    // getFstoreForumCategoryCollectionName
    // getFstoreForumCommentsCategoryCollectionName
    
    // Get the constant name of each FStore forum comments collection
    func getFstoreForumCategoryCollectionName(category: String) -> String {
        
        var categoryName: String
        
        switch category {
        case "General":
            categoryName = Constants.FStore.forumCollectionNameGeneral
        case "Depression":
            categoryName = Constants.FStore.forumCollectionNameDepression
        case "Stress and Anxiety":
            categoryName = Constants.FStore.forumCollectionNameStressAnxiety
        case "Relationships":
            categoryName = Constants.FStore.forumCollectionNameRelationships
        case "Recovery":
            categoryName = Constants.FStore.forumCollectionNameRecovery
        case "Addiction":
            categoryName = Constants.FStore.forumCollectionNameAddiction
        case "Sobriety":
            categoryName = Constants.FStore.forumCollectionNameSobriety
        case "Personal Stories":
            categoryName = Constants.FStore.forumCollectionNamePersonalStories
        case "Advice":
            categoryName = Constants.FStore.forumCollectionNameAdvice
        default:
            categoryName = Constants.FStore.forumCollectionNameGeneral
        }
        
        return categoryName
    }
    
    func reportForumPost(reasonForReport: Int) {
//        let reasonsForReport = ["Offensive", "Harmful or Dangerous", "Off Topic or Irrelevant", "Spam or Advertisment"]
        
        let documentRef = db.collection(getFstoreForumCategoryCollectionName(category: self.focusedPostCategoryName)).document(self.focusedPostID)
        
//        print("The post being reported: \(self.focusedPostID)")
        
        let field = "reportCount"
        documentRef.updateData([
            field: FieldValue.increment(Int64(1))
        ]) { err in
            if let err = err {
//                print("There was an error updating the reportCount \(err.localizedDescription)")
            } else {
//                print("Report count updated successfully")
            }
        }
    }
    
    func reportForumComment(reasonForreport: Int) {
//        print("comment being reported: \(self.focusedCommentID)")
        let documentRef = db.collection(getFstoreForumCommentsCategoryCollectionName(category: self.focusedPostCategoryName)).document(self.focusedCommentID)
        
        let field = "reportCount"
        documentRef.updateData([
            field: FieldValue.increment(Int64(1))
        ]) { err in
            if let err = err {
//                print("There was an error updating the report count: \(err.localizedDescription)")
            } else {
//                print("Comment report count updated successfully")
            }
        }
    }
}
