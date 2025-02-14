//
//  BottomNavBar.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 27/12/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct BottomNavBar: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("WarmBeige")) // TODO: maybe change the color
    }
    
    var body: some View {
        ZStack {
            TabView {
                HomeMainView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                HistoryMainView()
                    .tabItem {
                        Label("History", systemImage: "clock.fill")
                    }
                
                ForumMainView()
                    .tabItem {
                        Label("Forum", systemImage: "person.3.fill")
                    }
                
                ChatMainView(text: "")
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
                
                ProfileMainView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}
