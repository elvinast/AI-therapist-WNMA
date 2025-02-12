//
//  ForumCreateCommentView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 14/01/25.
//

import SwiftUI
import FirebaseAuth

struct ForumCreateCommentView: View {
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    @State var text: String = ""
    let title: String?
    let post: Post?
    
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
                        HStack {
                            // Author profile picture
                            // If the current user is the author and has a premium custom photo display it
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
                                    .foregroundColor(.white)
                                
                                // Date posted
                                Text(post.datePosted.formatted(date: .complete, time: .omitted))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .padding(.leading, 20)
                        // Post content
                        Text(post.postContent)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .foregroundColor(.white)
                        
                        // TODO: Make this same width as the HStack
                        Divider()
                            .background(Color.white)
                        
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 80)
                }
                

                HStack {
                    // Close popup Button
                    
                    Button(action: {
                        forumManager.isCreateCommentPopupShowing = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    
                    
                        Text("New Comment")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .center)
//                            .padding(.trailing, 10)
                    
                    
                    Button(action: {
                        print("User wanted to submit a comment with the following text: \(text)")
                        if let user = profileStateManager.userProfile {
                            if forumManager.focusedPostID != "" {
                                if forumManager.focusedPostCategoryName != "" {
                                    // Rate limiting check
                                    if let rateLimit = profileStateManager.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        if forumManager.publishComment(authorID: user.id!, authorUsername: user.displayName!, authorProfilePhoto: user.userPhotoNonPremium ?? "Selection Mix II", category: forumManager.focusedPostCategoryName, postID: forumManager.focusedPostID, content: text, isPremiumUser: user.isPremiumUser, lastCommentDate: user.lastForumCommentDate, numCommentsToday: user.numCommentsToday) == true {
                                            if user.isPremiumUser == false {
                                                profileStateManager.retrieveUserProfile(userID: user.id!)
                                            }
                                        }
                                        if forumManager.isErrorCreatingComment == false {
                                            forumManager.isCreateCommentPopupShowing = false
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Submit")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10)
                    .padding(.leading, 30)
                    
                    
                }
                
                if forumManager.isErrorCreatingComment {
                    Text(forumManager.errorText)
                        .foregroundColor(.red)
                        .font(.system(size: 14, design: .serif))
                }
                
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.blue, lineWidth: 4)
//                    .frame(maxWidth: 350, maxHeight: 100)
//                    .overlay(
//                        TextField("Enter comment here", text: $text)
//                            .padding(.leading, 20)
//                    )
                    
                TextField("Enter text", text: $text, axis: .vertical)
                    .font(.system(size: 20, design: .serif))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .lineLimit(5...10)
//                                    .frame(width: 300)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 300)
                    )
                
                Spacer()
                
            }
            .padding(.top, 100)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .scrollDismissesKeyboard(.immediately)
            
        }
        .onDisappear {
            forumManager.isErrorCreatingComment = false
            forumManager.errorText = ""
        }
    }
}

struct ForumCreateCommentView_Previews: PreviewProvider {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    static var previews: some View {
        ForumCreateCommentView(title: "General", post: Post(postID: "123", authorID: "1", category: "General", userPhoto: "default_prof_pic", username: "south", datePosted: Date.now, postContent: "Just the post content", likes: ["ac2323gf"], commentCount: 1, title: "General"))
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}
