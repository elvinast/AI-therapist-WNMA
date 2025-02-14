//
//  ChatManager.swift
//  AI-therapist
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
    static let openAiAPIKey = "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"
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
        
        collectionRef.addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving comments: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                DispatchQueue.main.async {
                    for document in querySnapshot.documents {
                        let message = Message(
                            id: document.documentID,
                            userID: document.data()["userID"] as? String,
                            isMessageFromUser: document.data()["isMessageFromUser"] as? Bool,
                            content: document.data()["content"] as? String,
                            date: document.data()["date"] as? Date)
                        self.messages.append(message)
                    }
                }
            }
        }
    }
    
    func classifyMessage(_ message: String, completion: @escaping (Bool) -> Void) {
        let classificationPrompt = """
        Classify the following message as 'therapy' or 'random'.
        If the message is related to mental health, emotions, or therapy, respond only with 'therapy'. Otherwise, respond with 'random'.

        Message: \(message)
        """

        let query = ChatQuery(messages: [.init(role: .user, content: classificationPrompt)!], model: .gpt4_o)

        openAI.chats(query: query) { result in
            switch result {
            case .success(let response):
                if let classification = response.choices.first?.message.content?.string?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    completion(classification.lowercased() == "therapy")
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }

    func sendMessage(
        userID: String,
        content: String,
        isPremiumUser: Bool?,
        lastMessageSendDate: Date?,
        numMessagesSentToday: Int?,
        completion: @escaping (Bool) -> Void
    ) {
        errorText = ""
        classifyMessage(content) { isValid in
            DispatchQueue.main.async {
                if !isValid {
                    self.isErrorSendingMessage = true
                    self.errorText = "Ask something related to your mental state and healthcare."
                    completion(false)
                    return
                }

                // Update Firestore with new message count
                self.db.collection("users").document(userID).updateData([
                    "lastMessageSendDate": Date(),
                    "numMessagesSentToday": (numMessagesSentToday ?? 0) + 1
                ]) { err in
                    if let err = err {
                        print("Error updating user chat fields: \(err)")
                    } else {
                        print("User chat fields updated successfully!")
                    }
                }

                let message = Message(userID: userID, isMessageFromUser: true, content: content, date: Date())
                self.messages.append(message)
                self.displayLoadingMessage = true

                let collectionName = Constants.FStore.messageCollectionName
                var ref: DocumentReference? = nil
                do {
                    try ref = self.db.collection(collectionName).addDocument(from: message)
                } catch {
                    print("Error saving message to Firestore: \(error.localizedDescription)")
                }

                // Generate OpenAI response
                let query = ChatQuery(messages: [.init(role: .user, content: content)!], model: .gpt3_5Turbo, maxTokens: 500)
                self.openAI.chats(query: query) { result in
                    DispatchQueue.main.async {
                        self.displayLoadingMessage = false
                        switch result {
                        case .success(let result):
                            if let response = result.choices.first?.message.content {
                                let responseMessage = Message(userID: userID, isMessageFromUser: false, content: response.string, date: Date())
                                self.messages.append(responseMessage)

                                do {
                                    try ref = self.db.collection(collectionName).addDocument(from: responseMessage)
                                } catch {
                                    print("Error saving response message to Firestore: \(error.localizedDescription)")
                                    self.isErrorSendingMessage = true
                                    self.errorText = "Failed to save message. Try again later."
                                }
                            }
                            completion(true)
                        case .failure(let error):
                            print("OpenAI API error: \(error.localizedDescription)")
                            self.isErrorSendingMessage = true
                            self.errorText = "AI response failed. Try again later."
                            completion(false)
                        }
                    }
                }
            }
        }
    }

    
    func clearMessages(userID: String) {
        let collectionRef = self.db.collection(Constants.FStore.messageCollectionName)
        let query = collectionRef.whereField("userID", isEqualTo: userID).order(by: "date", descending: false)
        
        query.getDocuments() { (snapshot, error) in
            if let err = error {
                print("error getting messages to delete: \(err.localizedDescription)")
                return
            }
            
            for document in snapshot!.documents {
                document.reference.delete() { error in
                    if let e = error {
                        print("error deleting document: \(e.localizedDescription)")
                    } else {
                        print("Document deleted!")
                    }
                }
            }
            self.messages = []
        }
    }
}
