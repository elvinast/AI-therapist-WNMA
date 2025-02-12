//
//  EntitlementManager.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 6/01/25.
//

import Foundation
import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.AI-therapist")!
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
