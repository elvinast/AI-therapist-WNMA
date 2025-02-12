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
    
    
    @State private var tabBarBackground = "Home_BG"
    
    var body: some View {
        ZStack {
            
//            Image(tabBarBackground)
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
            
            TabView() {
                Group {
                    HomeMainView()
                        .tabItem {
//                            Image(systemName: "house")
                            Label("Home", systemImage: "house")
                        }
                    
                    HistoryMainView()
                        .tabItem {
//                            Image(systemName: "clock.fill")
                            Label("History", systemImage: "clock.fill")
                        }
                    ForumMainView()
                        .tabItem {
//                            Image(systemName: "person.3.fill")
                            Label("Forum", systemImage: "person.3.fill")
                        }
                    ChatMainView(text: "")
                        .tabItem {
//                            Image(systemName: "message")
                            Label("Chat", systemImage: "message")
                        }
                    
                    ProfileMainView()
                        .tabItem {
//                            Image(systemName: "person.fill")
                            Label("Profile", systemImage: "person.fill")
                        }
                }
//                .toolbar(.visible, for: .tabBar)
//                .toolbarBackground(Color.white, for: .tabBar)
                .toolbarBackground(.clear, for: .tabBar)
                .toolbarBackground(.hidden, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
                
                // Find a way to always show the tab bar, OR go back on the comunity forum when the tab is switched to a non-community tab bar.
            }
            //                .edgesIgnoringSafeArea(.all)
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
