//
//  CheckIn.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 06/02/25.
//

import Foundation


public struct CheckIn: Codable {
    var userId: String?
    var date: String?
    var goals: [String]?
    var gratitude: String?
    var happinessScore: Double?
    var depressionScore: Double?
    var anxietyScore: Double?
    var journalEntry: String?
    // Premium Only
    var isPremiumCheckInPhoto: Bool?
}
