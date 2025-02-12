//
//  Constants.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import Foundation


struct Constants {
    static let appName = "Radiant"
    
    struct FStore {
        static let usersCollectionName = "users"
        static let userField = "user"
        static let bodyField = "body"
        static let dateField = "date"
        
        // Forum collection names
        static let forumCollectionNameGeneral = "forumGeneral"
        static let forumCollectionNameDepression = "forumDepression"
        static let forumCollectionNameStressAnxiety = "forumStressAnxiety"
        static let forumCollectionNameRelationships = "forumRelationships"
        static let forumCollectionNameRecovery = "forumRecovery"
        static let forumCollectionNameAddiction = "forumAddiction"
        static let forumCollectionNameSobriety = "forumSobriety"
        static let forumCollectionNamePersonalStories = "forumPersonalStories"
        static let forumCollectionNameAdvice = "forumAdvice"
        
        // Forum comments collection names
        static let commentsCollectionNameGeneral = "commentsGeneral"
        static let commentsCollectionNameDepression = "commentsDepression"
        static let commentsCollectionNameStressAnxiety = "commentsStressAnxiety"
        static let commentsCollectionNameRelationships = "commentsRelationships"
        static let commentsCollectionNameRecovery = "commentsRecovery"
        static let commentsCollectionNameAddiction = "commentsAddiction"
        static let commentsCollectionNameSobriety = "commentsSobriety"
        static let commentsCollectionNamePersonalStories = "commentsPersonalStories"
        static let commentsCollectionNameAdvice = "commentsAdvice"
        
        // Message collection name
        static let messageCollectionName = "messages"
    }
    
    struct GoogleMobileAds {
        static let testOnlyAdUnitId = "ca-app-pub-3940256099942544/3986624511"
    }
    
    struct AppleIDs {
        static let appleSignInServiceID = "com.bendreyer.radiant-applesigninid"
        static let appleSignInPrivateKeyName = "RadiantAppleSignInKey"
        static let appleSignInPrivateKeyID = "J4A348M8W5"
    }
    
    struct UserDefaults {
        static let emailKey = "emailKey"
        static let userLoggedInKey = "userLoggedInKey"
        static let isUserValidForBetaKey = "isUserValidForBetaKey"
        static let hasUserCompletedWelcomeSurveyKey = "hasUserCompletedWelcomeSurveyKey"
    }
}
