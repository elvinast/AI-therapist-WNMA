//
//  ForumSinglePostView.swift
//  Radiant
//
//  Created by Viiktoria Voevodina on 10/01/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

//import FirebaseFirestoreSwift

struct ForumSinglePostView: View {
    @Environment(\.presentationMode) var presentationMode // environment object that keeps track of what is shown
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    // Todo: Rework this view taking in a view as an argument, and make it the postID.
    //       Then use firebase to look up the info from that post
    @State var post: Post?
    @State var likeCount: Int
    @State var shouldLoadMoreCommentsButtonBeVisible: Bool = false
    
    let postID: String?
    let categoryName: String?
    
    @State var comments: [ForumPostComment] = []
    
    
    let db = Firestore.firestore()
    
    
    var body: some View {
        
        ZStack {
            // This is the background image.
            Image("Dark_Hills_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let post = post {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            // Author profile picture
                            // If the current user is the author and they have a custom profile photo, display it
                            
                            ZStack {
                                Image(post.userPhoto)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding(.trailing, 10)
                                
                                if let user = Auth.auth().currentUser?.uid {
                                    if user == self.post?.authorID {
                                        if let user = profileStateManager.userProfile {
                                            if let isPremium = user.isPremiumUser {
                                                if isPremium {
                                                    if let customPhoto = profileStateManager.premiumUserProfilePicture {
                                                        Image(uiImage: customPhoto)
                                                            .resizable()
                                                            .frame(width: 40, height: 40)
                                                            .clipShape(Circle())
                                                            .padding(.trailing, 10)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            VStack(alignment: .leading) {
                                
                                // Author Name
                                Text(post.username)
                                    .font(.system(size: 16, design: .serif))
                                
                                // Date posted
                                Text(post.datePosted.formatted(date: .complete, time: .omitted))
                                    .font(.system(size: 16, design: .serif))
                            }
                            
                        }
                        
                        // Post content
                        Text(post.postContent)
                            .font(.system(size: 14, design: .serif))
                        
                        VStack(alignment: .center) {
                            // TODO: Make this same width as the HStack
                            //                            Divider()
                            //                                .background(Color.white)
                            
                            // Post Action Button
                            HStack(alignment: .center) {
                                
                                Button(action: {
                                    if let user = profileStateManager.userProfile {
                                        // Rate Limiting Check (5 actions within one minute_
                                        if let rateLimit = profileStateManager.processFirestoreWrite() {
                                            print(rateLimit)
                                        } else {
                                            if forumManager.isFocusedPostLikedByCurrentUser {
                                                forumManager.removeLikeFromPost(postID: post.postID, postCategory: post.category, userID: user.id!)
                                                self.likeCount -= 1
                                            } else {
                                                forumManager.likePost(postID: post.postID, postCategory: post.category, userID: user.id!)
                                                self.likeCount += 1
                                            }
                                            forumManager.isFocusedPostLikedByCurrentUser = !forumManager.isFocusedPostLikedByCurrentUser
                                        }
                                    }
                                }) {
                                    if (forumManager.isFocusedPostLikedByCurrentUser) {
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                    } else {
                                        Image(systemName: "heart")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    
                                    Text("\(self.likeCount)")
                                    
                                    
                                }.padding(.trailing, 15)
                                
                                Button(action: {
                                    forumManager.isCreateCommentPopupShowing = true
                                }) {
                                    Image(systemName: "arrowshape.turn.up.left")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    //                                    .padding(.leading, 340)
                                }
                                .sheet(isPresented: $forumManager.isCreateCommentPopupShowing, onDismiss: {
                                    self.retrieveCommentsInit()
                                }) {
                                    ForumCreateCommentView(title: "ToDO: Add title", post: self.post)
                                }
                                .padding(.trailing, 20)
                                
                                
                                Button(action: {
                                    // Rate Limiting check
                                    if let rateLimit = profileStateManager.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        print("User wanted to report the post")
                                        print("The post that the user wanted to report: \(self.postID ?? "1")")
                                        forumManager.isReportPostAlertShowing = true
                                    }
                                }) {
                                    Image(systemName: "exclamationmark.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 10)
                                    //                                    .padding(.leading, 340)
                                }
                                .alert("Reason for report", isPresented: $forumManager.isReportPostAlertShowing) {
                                    Button("Offensive", action: {
                                        forumManager.reportForumPost(reasonForReport: 0)
                                    })
                                    Button("Harmful or Dangerous", action: {
                                        forumManager.reportForumPost(reasonForReport: 1)
                                    })
                                    Button("Off Topic or Irrelevant", action: {
                                        forumManager.reportForumPost(reasonForReport: 2)
                                    })
                                    Button("Spam or Advertisment", action: {
                                        forumManager.reportForumPost(reasonForReport: 3)
                                    })
                                    Button("Cancel", action: {
                                        forumManager.isReportPostAlertShowing = false
                                    })
                                }
                                .padding(.trailing, 20)
                                
                                // Delete post if signed in user is the author
                                if let user = Auth.auth().currentUser?.uid {
                                    if user == self.post?.authorID {
                                        Button(action: {
                                            // Rate limiting check
                                            if let rateLimit = profileStateManager.processFirestoreWrite() {
                                                print(rateLimit)
                                            } else {
                                                forumManager.isDeletePostPopupAlertShowing = true
                                            }
                                        }) {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .padding(.trailing, 10)
                                                .foregroundColor(.red)
                                        }
                                        .alert("Are you sure you want to delete your post?", isPresented: $forumManager.isDeletePostPopupAlertShowing) {
                                            Button("Yes", action: {
                                                forumManager.deletePost(postID: post.postID, postCategory: post.category, commentList: self.comments)
                                                self.presentationMode.wrappedValue.dismiss()
                                            })
                                            Button("Cancel", action: {
                                                forumManager.isDeletePostPopupAlertShowing = false
                                            })
                                        }
                                    }
                                }
                                
                                
                            }
                            Divider()
                                .background(Color.white)
                        }
                        // List of comments
                        
                        VStack() {
                            ScrollView {
                                ForEach(comments) { comment in
                                    HStack {
                                        Comment(commentID: comment.id!, authorID: comment.authorID!, username: comment.authorUsername ?? "Default username", userPhoto: comment.authorProfilePhoto, datePosted: comment.date ?? Date.now, commentCategory: comment.commentCategory!, commentContent: comment.content!, likes: comment.likes!, reportCount: comment.reportCount!, likeCount: comment.likes!.count, isCommentLikedByCurrentUser: comment.isCommentLikedByCurrentUser ?? true)
                                        
                                        Spacer()
                                    }
                                }
                                // Load more comments button
                                if self.shouldLoadMoreCommentsButtonBeVisible {
                                    Button(action: {
                                        retrieveNextTwentyComments()
                                    }) {
                                        Image(systemName: "arrow.down.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.bottom, 100)
                        }
                        
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    //                    .offset(y: -150)
                    .padding(.top, 150)
                }
            }
        }
        .foregroundColor(Color(uiColor: .white))
        .onAppear {
            retrievePost() // This also retrieves comments, it's nested
        }
    }
    
    func retrievePost() {
        let docRef = db.collection(forumManager.getFstoreForumCategoryCollectionName(category: forumManager.focusedPostCategoryName)).document(forumManager.focusedPostID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //                print("Document data: \(dataDescription)")
                self.post?.authorID = document.data()?["authorID"] as! String
                self.post?.postID = forumManager.focusedPostID
                self.post?.category = forumManager.focusedPostCategoryName
                if let authorProfilePhoto = document.data()?["authorProfilePhoto"] as? String {
                    self.post?.userPhoto = authorProfilePhoto
                } else {
                    self.post?.userPhoto = "default_prof_pic"
                }
                //                self.post?.userPhoto = document.data()!["authorProfilePhoto"] as! String
                self.post?.username = document.data()!["authorUsername"] as! String
                //                self.post?.datePosted = document.data()!["date"] as! Date
                let timestamp = document.data()!["date"] as! Timestamp
                self.post?.datePosted = timestamp.dateValue()
                self.post?.postContent = document.data()!["content"] as! String
                self.post?.likes = document.data()!["likes"] as! [String]
                self.post?.commentCount = 1
                
                // please work idk
                self.likeCount = self.post!.likes.count
                
                if let user = profileStateManager.userProfile {
                    if ((self.post?.likes.contains(user.id!)) == true) {
                        forumManager.isFocusedPostLikedByCurrentUser = true
                    } else {
                        forumManager.isFocusedPostLikedByCurrentUser = false
                    }
                }
                
                self.retrieveCommentsInit()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func retrieveCommentsInit() {
        self.comments = []
        let collectionName = forumManager.getFstoreForumCommentsCategoryCollectionName(category: self.post?.category ?? "General")

        let collectionRef = self.db.collection(collectionName).whereField("postID", isEqualTo: self.post?.postID ?? "1").limit(to: 20)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving comments: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let timestamp = document.data()["date"] as? Timestamp
                    var comment = ForumPostComment(
                        id: document.documentID,
                        postID: document.data()["postID"] as? String,
                        parentCommentID: document.data()["parentCommentID"] as? String,
                        authorID: document.data()["authorID"] as? String,
                        authorUsername: document.data()["authorUsername"] as? String,
                        authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                        date: timestamp?.dateValue(),
                        commentCategory: document.data()["commentCategory"] as? String,
                        content: document.data()["content"] as? String,
                        likes: document.data()["likes"] as? [String],
                        reportCount: document.data()["reportCount"] as? Int,
                        isCommentLikedByCurrentUser: false)
                    
                    if let user = profileStateManager.userProfile {
                        if ((comment.likes!.contains(user.id!)) == true) {
                            comment.isCommentLikedByCurrentUser = true
                        } else {
                            comment.isCommentLikedByCurrentUser = false
                        }
                    }
                    
                    comments.append(comment)
                }
                forumManager.lastComment = querySnapshot.documents.last
                if self.comments.count >= 20 {
                    self.shouldLoadMoreCommentsButtonBeVisible = true
                }
            }
        }
    }
    
    func retrieveNextTwentyComments() {
        var numCommentsInCurrentBatch = 0
        let collectionName = forumManager.getFstoreForumCommentsCategoryCollectionName(category: self.post?.category ?? "General")
        
        let next = db.collection(collectionName).whereField("postID", isEqualTo: self.post?.postID ?? "1").start(afterDocument: forumManager.lastComment!).limit(to: 20)
        
        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retrieving next batch of comments")
                return
            }
            
            for document in snapshot.documents {
                let timestamp = document.data()["date"] as? Timestamp
                var comment = ForumPostComment(
                    id: document.documentID,
                    postID: document.data()["postID"] as? String,
                    parentCommentID: document.data()["parentCommentID"] as? String,
                    authorID: document.data()["authorID"] as? String,
                    authorUsername: document.data()["authorUsername"] as? String,
                    authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                    date: timestamp?.dateValue(),
                    commentCategory: document.data()["commentCategory"] as? String,
                    content: document.data()["content"] as? String,
                    likes: document.data()["likes"] as? [String],
                    reportCount: document.data()["reportCount"] as? Int,
                    isCommentLikedByCurrentUser: false)
                
                if let user = profileStateManager.userProfile {
                    if ((comment.likes!.contains(user.id!)) == true) {
                        comment.isCommentLikedByCurrentUser = true
                    } else {
                        comment.isCommentLikedByCurrentUser = false
                    }
                }
                
                comments.append(comment)
                numCommentsInCurrentBatch += 1
            }
            
            // No more comments
            if numCommentsInCurrentBatch < 20 {
                self.shouldLoadMoreCommentsButtonBeVisible = false
            }
            
            guard let lastDocument = snapshot.documents.last else {
                // the collection is empty
                return
            }
            forumManager.lastComment = lastDocument
        }
    }
}

//struct ForumSinglePostView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForumSinglePostView(post: nil, likeCount: 0, postID: "1", categoryName: "eh")
//            .environmentObject(ProfileStatusManager())
//            .environmentObject(ForumManager())
//    }
//}


struct Comment: View {
    @Environment(\.presentationMode) var presentationMode // environment object that keeps track of what is shown
    
    @EnvironmentObject var forumManager: ForumManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    let commentID: String
    let authorID: String
    let username: String
    let userPhoto: String?
    let datePosted: Date
    let commentCategory: String
    let commentContent: String
    var likes: [String]
    var reportCount: Int
    
    @State var likeCount: Int
    @State var isCommentLikedByCurrentUser: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Author profile picture
                // If the current user is the comment author and has a premium custom photo, display it
                ZStack {
                    Image(userPhoto ?? "Selection Mix II")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    
                    if let user = Auth.auth().currentUser?.uid {
                        if user == self.authorID {
                            if let user = profileStateManager.userProfile {
                                if let isPremium = user.isPremiumUser {
                                    if isPremium {
                                        if let customPhoto = profileStateManager.premiumUserProfilePicture {
                                            Image(uiImage: customPhoto)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                VStack(alignment: .leading) {
                    // Author Name
                    Text(self.username)
                        .font(.system(size: 14, design: .serif))
                    
                    // Date posted
                    Text(self.datePosted.formatted(date: .complete, time: .omitted))
                        .font(.system(size: 14, design: .serif))
                }
            }
            Text(self.commentContent)
                .font(.system(size: 13, design: .serif))
            
            HStack {
                // Like comment
                Button(action: {
                    
                    if let rateLimit = profileStateManager.processFirestoreWrite() {
                        print(rateLimit)
                    } else {
                        if let user = profileStateManager.userProfile {
                            if self.isCommentLikedByCurrentUser {
                                forumManager.removeLikeFromComment(commentID: self.commentID, commentCategory: self.commentCategory, userID: user.id!)
                                self.likeCount -= 1
                            } else {
                                forumManager.likeComment(commentID: self.commentID, commentCategory: self.commentCategory, userID: user.id!)
                                self.likeCount += 1
                            }
                            
                            self.isCommentLikedByCurrentUser = !self.isCommentLikedByCurrentUser
                        }
                    }
                }) {
                    if self.isCommentLikedByCurrentUser {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 14, height: 14)
                    }
                    Text("\(self.likeCount)")
                        .font(.system(size: 12))
                }
                
                // Report
                Button(action: {
                    // Rate Limiting check
                    if let rateLimit = profileStateManager.processFirestoreWrite() {
                        print(rateLimit)
                    } else {
                        print("User wanted to report the comment")
                        print("The comment that the user wanted to report: \(self.commentID)")
                        forumManager.focusedCommentID = self.commentID
                        forumManager.isReportCommentAlertShowing = true
                    }
                }) {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 14, height: 14)
                }
                .alert("Reason for report", isPresented: $forumManager.isReportCommentAlertShowing) {
                    Button("Offensive", action: {
                        forumManager.reportForumComment(reasonForreport: 0)
                    })
                    Button("Harmful or Dangerous", action: {
                        forumManager.reportForumComment(reasonForreport: 1)
                    })
                    Button("Off Topic or Irrelevant", action: {
                        forumManager.reportForumComment(reasonForreport: 2)
                    })
                    Button("Spam or Advertisment", action: {
                        forumManager.reportForumComment(reasonForreport: 3)
                    })
                    Button("Cancel", action: {
                        forumManager.isReportCommentAlertShowing = false
                    })
                }
                
                if let user = Auth.auth().currentUser?.uid {
                    if user == self.authorID {
                        Button(action: {
                            // rate limiting check
                            if let rateLimit = profileStateManager.processFirestoreWrite() {
                                print(rateLimit)
                            } else {
                                forumManager.isDeleteCommentPopupAlertShowing = true
                            }
                        }) {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 10)
                                .foregroundColor(.red)
                        }
                        .alert("Are you sure you want to delete your post?", isPresented: $forumManager.isDeleteCommentPopupAlertShowing) {
                            Button("Yes", action: {
                                forumManager.deleteComment(commentID: self.commentID, commentCategory: self.commentCategory, authorID: user)
                            })
                            Button("Cancel", action: {
                                forumManager.isDeleteCommentPopupAlertShowing = false
                            })
                        }
                    }
                }
            }
            
        }
        .padding(.trailing, 40)
    }
}
