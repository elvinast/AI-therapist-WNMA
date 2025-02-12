//
//  EntitlementManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 10/22/23.
//

import Foundation
import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.radiant")!
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
