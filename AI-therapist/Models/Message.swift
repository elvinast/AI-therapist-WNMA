//
//  Message.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 03/02/25.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: String?
    // The user that this message belongs to
    var userID: String?
    // Denotes if this is a message from the user or the chat bot
    var isMessageFromUser: Bool?
    // Message body
    var content: String?
    // Date time
    var date: Date?
}
