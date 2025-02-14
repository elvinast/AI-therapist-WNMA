//
//  ForumDetailedView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 08/01/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ForumDetailedView: View {
    
    let title: String?
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    @State var posts: [ForumPost] = []
    @State var shouldLoadMorePostsButtonBeVisible: Bool = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("SoftCoral")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                 .edgesIgnoringSafeArea(.all)
            
            // Post List
            
            VStack {
                // Icons
                HStack {
                    // Create Post
                    Button(action: {
                        forumManager.isCreatePostPopupShowing = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .sheet(isPresented: $forumManager.isCreatePostPopupShowing) {
                        ForumCreatePostView(title: title)
                            .onDisappear(perform: {
                                retrievePostsInit()
                            })
                    }
                }
                .padding(.leading, 300)
                .padding(.top, 1)
                
                Text(title ?? "Category Title")
                    .font(.system(size: 24, design: .serif))
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        // look up the username with their id
                        ForEach(posts, id: \.id) { post in
                            if post.id != nil {
                                Post(postID: post.id!, authorID: post.authorID!, category: self.title ?? "General", userPhoto: post.authorProfilePhoto ?? "default_prof_pic", username: post.authorUsername ?? "Username missing", datePosted: post.date!, postContent: post.content!, likes:post.likes ?? [], commentCount: 1, title: self.title)
                                    .id(post.id)
                            } else {
                                Text("Unable to retrieve post")
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    .padding(.leading, 20)
                    .padding(.bottom, 1)
                    

                    // Load more posts button
                    if self.shouldLoadMorePostsButtonBeVisible {
                        Button(action: {
                            retrieveNextTwentyPosts()
                        }) {
                            Image(systemName: "arrow.down.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .padding(.bottom, 40)
                .offset(y: -60)
                .padding(.top, 40)
                
            }.padding(.top, 8)
        }
        .foregroundColor(Color(uiColor: .gray))
        .onAppear {
            retrievePostsInit()
        }
    }
    
    
    func retrievePostsInit() {
        self.posts = []
        let collectionName = forumManager.getFstoreForumCategoryCollectionName(category: self.title ?? "General")
        
        let collectionRef = self.db.collection(collectionName).order(by: "date", descending: true).limit(to: 20)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving posts: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    var post = ForumPost(
                        id: document.documentID,
                        authorID: document.data()["authorID"] as? String,
                        authorUsername: document.data()["authorUsername"] as? String,
                        authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                        category: document.data()["category"] as? String,
                        //                        date: document.data()["date"] as? Date,
                        timestamp: document.data()["date"] as? Timestamp,
                        content: document.data()["content"] as? String,
                        likes: document.data()["likes"] as? [String])
                    
                    // Date
                    post.date = post.timestamp?.dateValue()
                    self.posts.append(post)
                }
                forumManager.lastDoc = querySnapshot.documents.last
                if self.posts.count >= 20 {
                    self.shouldLoadMorePostsButtonBeVisible = true
                }
            }
        }
    }
    
    func retrieveNextTwentyPosts() {
        var numPostsInCurrentBatch = 0
        let collectionName = forumManager.getFstoreForumCategoryCollectionName(category: self.title ?? "General")
        
        let next = db.collection(collectionName).order(by: "date", descending: true).start(afterDocument: forumManager.lastDoc!).limit(to: 20)
        
        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("error retrieving next set of posts: \(error?.localizedDescription ?? "x")")
                return
            }
            
            for document in snapshot.documents {
                var post = ForumPost(
                    id: document.documentID,
                    authorID: document.data()["authorID"] as? String,
                    authorUsername: document.data()["authorUsername"] as? String,
                    authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                    category: document.data()["category"] as? String,
                    //                        date: document.data()["date"] as? Date,
                    timestamp: document.data()["date"] as? Timestamp,
                    content: document.data()["content"] as? String,
                    likes: document.data()["likes"] as? [String])
                
                // Date
                post.date = post.timestamp?.dateValue()
                self.posts.append(post)
                numPostsInCurrentBatch += 1
            }
            
            // No more posts
            if numPostsInCurrentBatch < 20 {
                self.shouldLoadMorePostsButtonBeVisible = false
            }
            
            guard let lastDocument = snapshot.documents.last else {
                // The collection is empty
                return
            }
            
            forumManager.lastDoc = lastDocument
        }
    }
}

struct ForumDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForumDetailedView(title: "Title")
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}


struct Post: View {
    var postID: String
    var authorID: String
    var category: String
    var userPhoto: String
    var username: String
    var datePosted: Date
    var postContent: String
    var likes: [String]
    
    @State var commentCount: Int
    
    let title: String?
    
    let dateFormatter = DateFormatter()
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager

    
    var body: some View {
        // Post
        
        NavigationLink(destination: ForumSinglePostView(post: Post(postID: "0", authorID: "1", category: "0", userPhoto: "default_prof_pic", username: "0", datePosted: Date.now, postContent: "0", likes: [], commentCount: 1, title: "1"), likeCount: 0, postID: nil, categoryName: nil)) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        // User profile picture
                        // If the current user is the author and has a premium custom photo, display that
                        ZStack {
                            Image(userPhoto)
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
                            // username
                            Text(username)
                                .font(.system(size: 14, design: .serif))
                                .bold()
                            // date posted
                            Text(datePosted.formatted(date: .complete, time: .omitted))
                                .font(.system(size: 14, design: .serif))
                        }
                        
                    }
                    // post content
                    Text(postContent)
                        .padding(.bottom, 5)
                        .font(.system(size: 12, design: .serif))
                    // interact buttons
                    HStack {
                        // Like post
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(likes.count)")
                        
                        // Comment count (opens single post view)
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 18, height: 18)

                        Text("\(commentCount)")
                        
                        // Report
                        Button(action: {
                            
                            // Rate limiting check
                            if let rateLimit = profileStateManager.processFirestoreWrite() {
                                print(rateLimit)
                            } else {
                                print("User wanted to report the post")
                                print("The post that the user wanted to report: \(self.postID)")
                                forumManager.focusedPostID = self.postID
                                forumManager.focusedPostCategoryName = self.category
                                forumManager.isReportPostAlertShowing = true
                            }
                        }) {
                            Image(systemName: "exclamationmark.circle")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }.alert("Reason for report", isPresented: $forumManager.isReportPostAlertShowing) {
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
                        
                    }
                }
                .padding(.bottom, 10)
        }
        .simultaneousGesture(TapGesture().onEnded{
            print("The post ID that was clicked on: \(self.postID)")
            forumManager.focusedPostID = self.postID
            forumManager.focusedPostCategoryName = self.category
        })

        
        Divider()
            .background(Color.gray)
    }
}
