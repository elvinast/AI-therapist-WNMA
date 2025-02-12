//
//  RadiantApp.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
//import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let storage = Storage.storage()
        print("Database: \(db)")
        
//        // Initialize the Google Mobile Ads SDK.
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // print the login status of the user
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
struct RadiantApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject
        private var entitlementManager: EntitlementManager

    @StateObject
    private var purchaseManager: PurchaseManager
    
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager()
        
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(entitlementManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
