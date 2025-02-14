//
//  ForumMainView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 07/01/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ForumMainView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var forumManager = ForumManager()
    
    // Controls display of sidebar
    @State var showSidebar: Bool = false
    
    var body: some View {
        
        SideBarStack(sidebarWidth: 320, showSidebar: $showSidebar) {
            NavigationView {
                ZStack {
                    VStack {
                        HStack {
                            if let profPic = profileStateManager.userProfile?.userPhotoNonPremium {
                                Image(profPic)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image("default_prof_pic")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                            
                            if let displayName = profileStateManager.userProfile?.displayName {
                                Text(displayName)
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundColor(.black)
                            } else {
                                Text("User")
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 15)
                        
                        VStack(spacing: 15) {
                            NavigationLink(destination: MyPosts(userID: profileStateManager.userProfile?.id), label: {
                                CustomButton(title: "My Posts")
                            })
                            
                            NavigationLink(destination: MyComments(userID: profileStateManager.userProfile?.id), label: {
                                CustomButton(title: "My Comments")
                            })
                            
                            NavigationLink(destination: LikedPosts(userID: profileStateManager.userProfile?.id), label: {
                                CustomButton(title: "Liked Posts")
                            })
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 400)
                }
            }.environmentObject(forumManager)
            
        } content: {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("WarmBeige")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing)
                         .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Button(action: {
                                showSidebar = true
                            }) {
                                Image(systemName: "text.alignleft")
                                    .resizable()
                                    .frame(width: 24, height: 20)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        
                        ForumCategoriesView()
                            .padding(.top, 10)
                    }
                }
            }
            .foregroundColor(.black)
            .environmentObject(forumManager)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Custom Button for Navigation Links
struct CustomButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color("SoftCoral"))
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}


struct ForumMainView_Previews: PreviewProvider {
    static var previews: some View {
        ForumMainView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}


struct MyPosts: View {
    @EnvironmentObject var forumManager: ForumManager
    
    let db = Firestore.firestore()
    
    let userID: String?
    @State var posts: [ForumPost] = []
    
    var body: some View {
        
        HStack {
            Text("My Posts")
                .font(.system(size: 18, design: .serif))
        }
        .padding(.bottom, 15)
        
        ScrollView {
            VStack(alignment: .leading) {
                // look up the username with their id
                ForEach(posts, id: \.id) { post in
                    if post.id != nil {
                        Post(postID: post.id!, authorID: post.authorID!, category: post.category!, userPhoto: post.authorProfilePhoto ?? "default_prof_pic", username: post.authorUsername ?? "author", datePosted: post.date ?? Date.now, postContent: post.content!, likes:post.likes ?? [], commentCount: 1, title: post.category!)
                            .id(post.id)
                    } else {
                        Text("Unable to retrieve post")
                    }
                }
            }
            .padding(.trailing, 30)
            .padding(.leading, 20)
            .padding(.bottom, 1)
        }
        .onAppear {
            retrieveMyPosts()
        }
        .padding(.bottom, 40)
        
    }
    
    
    func retrieveMyPosts() {
        self.posts = []
        print("user wanted to retrieve their posts, id: \(userID!)")
        
        // option 1: call every collection
        queryCollection(collectionName: "General")
        queryCollection(collectionName: "Depression")
        queryCollection(collectionName: "Stress and Anxiety")
        queryCollection(collectionName: "Relationships")
        queryCollection(collectionName: "Recovery")
        queryCollection(collectionName: "Addiction")
        queryCollection(collectionName: "Sobriety")
        queryCollection(collectionName: "Personal Stories")
        queryCollection(collectionName: "Advice")
        
    }
    
    
    func queryCollection(collectionName: String) {
        let collection = forumManager.getFstoreForumCategoryCollectionName(category: collectionName)
        
        let collectionRef = self.db.collection(collection).whereField("authorID", isEqualTo: self.userID!)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving posts: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let post = ForumPost(
                        id: document.documentID,
                        authorID: document.data()["authorID"] as? String,
                        authorUsername: document.data()["authorUsername"] as? String,
                        authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                        category: document.data()["category"] as? String,
                        date: document.data()["date"] as? Date,
                        content: document.data()["content"] as? String,
                        likes: document.data()["likes"] as? [String])
                    posts.append(post)
                }
            }
        }
    }
}

struct MyComments: View {
    @EnvironmentObject var forumManager: ForumManager
    let db = Firestore.firestore()
    let userID: String?
    
    @State var comments: [ForumPostComment] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("My Comments")
            }
            .padding(.bottom, 15)
            ScrollView {
                ForEach(comments) { comment in
                    Comment(commentID: comment.id!, authorID: comment.authorID!, username: comment.authorUsername ?? "author", userPhoto: comment.authorProfilePhoto ?? "default_prof_pic", datePosted: comment.date ?? Date.now, commentCategory: comment.commentCategory!, commentContent: comment.content!, likes: comment.likes!, reportCount: comment.reportCount!, likeCount: comment.likes!.count, isCommentLikedByCurrentUser: comment.isCommentLikedByCurrentUser ?? true)
                    Divider()
                }
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            retrieveMyComments()
        }
    }
    
    func retrieveMyComments() {
        self.comments = []
        print("user wanted to retrieve their comments, id: \(userID!)")
        
        // option 1: call every collection
        queryCommentCollection(collectionName: "General")
        queryCommentCollection(collectionName: "Depression")
        queryCommentCollection(collectionName: "Stress and Anxiety")
        queryCommentCollection(collectionName: "Relationships")
        queryCommentCollection(collectionName: "Recovery")
        queryCommentCollection(collectionName: "Addiction")
        queryCommentCollection(collectionName: "Sobriety")
        queryCommentCollection(collectionName: "Personal Stories")
        queryCommentCollection(collectionName: "Advice")
        
    }
    
    func queryCommentCollection(collectionName: String) {
        let collection = forumManager.getFstoreForumCommentsCategoryCollectionName(category: collectionName)
        
        let collectionRef = self.db.collection(collection).whereField("authorID", isEqualTo: self.userID!)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving posts: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let comment = ForumPostComment(
                        id: document.documentID,
                        postID: document.data()["postID"] as? String,
                        authorID: document.data()["authorID"] as? String,
                        authorUsername: document.data()["authorUsername"] as? String,
                        authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                        date: document.data()["date"] as? Date,
                        commentCategory: document.data()["commentCategory"] as? String,
                        content: document.data()["content"] as? String,
                        likes: document.data()["likes"] as? [String],
                        reportCount: document.data()["reportCount"] as? Int)
                    comments.append(comment)
                }
            }
        }
    }
}


struct LikedPosts: View {
    @EnvironmentObject var forumManager: ForumManager
    let db = Firestore.firestore()
    
    let userID: String?
    @State var posts: [ForumPost] = []
    
    var body: some View {
        HStack {
            Text("Liked Posts")
        }
        .padding(.bottom, 15)
        ScrollView {
            VStack(alignment: .leading) {
                // look up the username with their id
                ForEach(posts, id: \.id) { post in
                    if post.id != nil {
                        Post(postID: post.id!, authorID: post.authorID!, category: post.category!, userPhoto: post.authorProfilePhoto ?? "default_prof_pic", username: post.authorUsername ?? "author", datePosted: post.date ?? Date.now, postContent: post.content!, likes:post.likes ?? [], commentCount: 1, title: post.category!)
                            .id(post.id)
                    } else {
                        Text("Unable to retrieve post")
                    }
                }
            }
            .padding(.trailing, 30)
            .padding(.leading, 20)
            .padding(.bottom, 1)
        }
        .onAppear {
            retrieveLikedPosts()
        }
        .padding(.bottom, 40)
    }
    
    func retrieveLikedPosts() {
        self.posts = []
        print("user wanted to retrieve their liked posts, id: \(userID!)")
        
        // option 1: call every collection
        queryCollectionForLikedPosts(collectionName: "General")
        queryCollectionForLikedPosts(collectionName: "Depression")
        queryCollectionForLikedPosts(collectionName: "Stress and Anxiety")
        queryCollectionForLikedPosts(collectionName: "Relationships")
        queryCollectionForLikedPosts(collectionName: "Recovery")
        queryCollectionForLikedPosts(collectionName: "Addiction")
        queryCollectionForLikedPosts(collectionName: "Sobriety")
        queryCollectionForLikedPosts(collectionName: "Personal Stories")
        queryCollectionForLikedPosts(collectionName: "Advice")
    }
    
    func queryCollectionForLikedPosts(collectionName: String) {
        let collection = forumManager.getFstoreForumCategoryCollectionName(category: collectionName)
        
        let collectionRef = self.db.collection(collection).whereField("likes", arrayContains: self.userID!)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving posts: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let post = ForumPost(
                        id: document.documentID,
                        authorID: document.data()["authorID"] as? String,
                        authorUsername: document.data()["authorUsername"] as? String,
                        authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                        category: document.data()["category"] as? String,
                        date: document.data()["date"] as? Date,
                        content: document.data()["content"] as? String,
                        likes: document.data()["likes"] as? [String])
                    posts.append(post)
                }
            }
        }
        
    }
}
