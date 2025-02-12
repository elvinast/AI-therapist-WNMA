//
//  ChatManager.swift
//  Radiant
//
//  Created by Viiktoria Voevodina on 10/01/25.
//

import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import OpenAI

struct Secrets {
    static let openAiAPIKey = "YOUR_API_KEY"
}

class ChatManager: ObservableObject {
    let db = Firestore.firestore()
    
    let openAI = OpenAI(apiToken: Secrets.openAiAPIKey)
    
    @Published var displayLoadingMessage: Bool = false
    @Published var messages: [Message] = []
    @Published var currentId = 0
    
    @Published var isErrorSendingMessage: Bool = false
    @Published var errorText: String = ""
    
    
    init() {
        if let user = Auth.auth().currentUser?.uid {
            retrieveMessages(userID: user)
        }
    }
    
    func retrieveMessages(userID: String) {
        self.messages = []
        
        let collectionRef = self.db.collection(Constants.FStore.messageCollectionName).whereField("userID", isEqualTo: userID).order(by: "date", descending: false)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving comments: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let message = Message(
                        id: document.documentID,
                        userID: document.data()["userID"] as? String,
                        isMessageFromUser: document.data()["isMessageFromUser"] as? Bool,
                        content: document.data()["content"] as? String,
                        date: document.data()["date"] as? Date)
                    self.messages.append(message)
//                    print("Message was retrieved, messageID: \(document.documentID), message content: \(document.data()["content"] as? String ?? "No Content")")
                }
            }
        }
    }
    
    func sendMessage(userID: String, content: String, isPremiumUser: Bool?, lastMessageSendDate: Date?, numMessagesSentToday: Int?) -> Bool {
        
        // Free user rate limiting check
        var newNumMessagesToday = 0
        if let premium = isPremiumUser {
            if premium == false {
                if let lastMessageSendDate = lastMessageSendDate {
                    // Get current date
                    let currentDate = Date()
                    // Check if last message was sent today
                    if lastMessageSendDate > (currentDate - 86400) {
                        if let numMessagesSentToday = numMessagesSentToday {
                            if numMessagesSentToday >= 5 {
                                self.isErrorSendingMessage = true
                                self.errorText = "You've sent the max amount of messages today. Upgrate to premium to send unlimited chat messages."
                                return false
                            } else {
                                newNumMessagesToday = numMessagesSentToday
                            }
                        }
                    } else {
                        newNumMessagesToday = 0
                    }
                }
                // Free user hasn't reached message quota. Write to their userProfile. Don't write for premium users
                db.collection("users").document(userID).updateData([
                    "lastMessageSendDate": Date(),
                    "numMessagesSentToday": newNumMessagesToday + 1
                ]) { err in
                    if let err = err {
                        print("Error updating user chat fields: \(err)")
                    } else {
                        print("User chat fields updated successfully written!")
                    }
                }
            }
        }
        
        if content.count > 300 {
//            print("Message length too long")
            self.isErrorSendingMessage = true
            self.errorText = "Message length is too long"
            return false
        }
        
        let message = Message(id: "\(self.currentId)", userID: userID, isMessageFromUser: true, content: content, date: Date.now)
        self.currentId += 1
        // Firebase will assign it's own id
        let messageForFirebase = Message(userID: userID, isMessageFromUser: true, content: content, date: Date.now)
        self.messages.append(message)
        self.displayLoadingMessage = true
        
        let collectionName = Constants.FStore.messageCollectionName
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: messageForFirebase)
//            print("successfully saved message to db")
        } catch {
//            print("Error saving message to firestore")
        }

                
        // Generate OpenAI response
        let query = ChatQuery(messages: [.init(role: .user, content: content)!], model: .gpt3_5Turbo /*, maxTokens: 60*/)
        openAI.chats(query: query) { result in
          // Handle result here
            switch result {
            case .success(let result):
                if let response = result.choices[0].message.content {
//                    print("OPENAI RESPONSE: \(response)")
                    let responseMessage = Message(id: "\(self.currentId)", userID: userID, isMessageFromUser: false, content: "\(response)", date: Date.now)
                    self.currentId += 1
                    let responseMessageForFirebase = Message(userID: userID, isMessageFromUser: false, content: "\(response)", date: Date.now)
                    do {
                        try ref = self.db.collection(collectionName).addDocument(from: responseMessageForFirebase)
//                        print("successfully saved response message to db")
//                        self.retrieveMessages(userID: userID)
                        self.displayLoadingMessage = false
                        self.messages.append(responseMessage)
                    } catch {
//                        print("Error saving response message to firestore")
                    }
                } else {
//                    print("Response from openAI empty")
                }
            case .failure(let error):
//                print("Error getting result: \(error.localizedDescription)")
                break
            }
        }
        return true
    }
    
    func clearMessages(userID: String) {
//        print("user wanted to reset chat")
        // lookup and delete all messages where the userID = userID
        let collectionRef = self.db.collection(Constants.FStore.messageCollectionName)
        let query = collectionRef.whereField("userID", isEqualTo: userID)
        
        query.getDocuments() { (snapshot, error) in
            if let err = error {
//                print("error getting messages to delete: \(err.localizedDescription)")
                return
            }
            
            for document in snapshot!.documents {
                document.reference.delete() { error in
                    if let e = error {
//                        print("error deleting document: \(e.localizedDescription)")
                    } else {
//                        print("Document deleted!")
                    }
                }
            }
            self.messages = []
        }
    }
    
}
