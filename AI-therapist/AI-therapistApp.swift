//
//  AI-therapistApp.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 15/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        _ = Storage.storage()
        print("Database: \(db)")
    
        if let loginStatus = UserDefaults.standard.object(forKey: loginStatusKey) as? Bool {
            print("User login status on app launch finish: \( loginStatus )")
        } else {
            print("User login status on app launch finish: \( String(describing: UserDefaults.standard.object(forKey: loginStatusKey)) ))")
            UserDefaults.standard.set(false, forKey: loginStatusKey)
        }
        
        return true
    }
}

@main
struct AITherapistApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject
        private var entitlementManager: EntitlementManager
    
    init() {
        let entitlementManager = EntitlementManager()
        
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(entitlementManager)
        }
    }
}
