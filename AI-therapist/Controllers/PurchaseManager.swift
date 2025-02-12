//
//  PurchaseManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 10/15/23.
//

import Foundation
import StoreKit
import FirebaseFirestore
import FirebaseAuth

// TODO: remove pro subscription

@MainActor
class PurchaseManager: NSObject, ObservableObject {
    
    private let productIds = ["PremiumMonthly", "PremiumYearly"]
    
    @Published
    private(set) var products: [Product] = []
    private var productsLoaded = false
    
    @Published private(set) var purchasedProductIds = Set<String>()
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIds.isEmpty
    }
    
    private var updates: Task<Void, Never>? = nil
    
    override init() {
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            print(error)
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
    
    //TODO(): update this function to take the isPremiumUser bool from the already fetched user profile instead of making an extra call to firestore in this class.
    func updatePurchasedProducts() async {
        
        // Firebase Firestore
        let db = Firestore.firestore()
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                print("gaurd case .verfied on transaction")
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIds.insert(transaction.productID)
                print("Apple found that u already have a premium acccount")
                
                // Add code to update isPremium boolean on userProfile in firestore.
                // (We can assume the only type of product being added is premium subscription, so no need to check which product is being added).
                // Try to get current signed in user
                if let user = Auth.auth().currentUser {
                    let userDocRef = db.collection("users").document(user.uid)
                    
                    // read the is premium field, if it's already true do nothing, else switch it to true.
                    userDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let isPremium = document.data()!["isPremiumUser"] as! Bool
                            if !isPremium {
                                userDocRef.updateData([
                                    "isPremiumUser": true,
                                ]) { err in
                                    if let err = err {
                                        print(err.localizedDescription)
                                    } else {
                                        print("user status updated to premium")
                                    }
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            } else {
                self.purchasedProductIds.remove(transaction.productID)
                print("Apple thinks you are no longer subscibed to premium account")
                
                // Add code to update isPremium boolean on userProfile in firestore.
                // (We can assume the only type of product being added is premium subscription, so no need to check which product is being added).
                // Try to get current signed in user
                if let user = Auth.auth().currentUser {
                    let userDocRef = db.collection("users").document(user.uid)
                    
                    // read the is premium field, if it's already false do nothing, else switch it to false.
                    userDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let isPremium = document.data()!["isPremiumUser"] as! Bool
                            if isPremium {
                                userDocRef.updateData([
                                    "isPremiumUser": false,
                                ]) { err in
                                    if let err = err {
                                        print(err.localizedDescription)
                                    } else {
                                        print("user premium status removed")
                                    }
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // buy this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}

