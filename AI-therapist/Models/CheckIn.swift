//
//  CheckIn.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/11/23.
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
