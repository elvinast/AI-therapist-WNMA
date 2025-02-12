//
//  Message.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/1/23.
//

import Foundation

struct Message: Codable, Identifiable {
    // Firebase will assign a docID automatically
//    @DocumentID var id: String?
    // this ID is necessary for swift to display messages in a list in the UI.
    // At read time, assign the firebase @docID to this var, don't set the ID when writing to database
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
