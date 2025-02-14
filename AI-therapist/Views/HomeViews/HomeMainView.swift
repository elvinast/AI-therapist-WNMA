//
//  HomeMainView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 22/12/24.
//

// Testing again, after

import SwiftUI
import UIKit
import Charts
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices

struct HomeMainView: View {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var homeManager = HomeManager()
    
    @State private var todaysDate = Date()
    
    @State var goalOneComplete = true
    @State var goalTwoComplete = false
    @State var goalThreeComplete = true
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("WarmBeige"), Color("SoftCoral")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack {
                        Text ("Hi, \(homeManager.userFirstName)!")
                            .foregroundColor(.black)
                            .font(.system(size: 18, design: .serif))
                            .animation(.easeInOut(duration: 1.0))
                        Spacer()
                        
                        // AI-therapist Icon
                        Image("AI-therapist_App_Icon_Transparent")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
//                    .padding(.top, 40)
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                    
                    
                    
                    VStack(alignment: .center) {
                        // Date
                        Text(todaysDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 30, design: .serif))
                            .foregroundColor(.black)
                            .bold()
                        
                        
                    }
                    .padding(.bottom, 10)
                    
                    
                    ScrollView {
                        VStack {
                            // Daily Affirmation
                            Text(homeManager.quoteOfTheDay)
                                .foregroundColor(.black)
                                .italic()
                                .font(.system(size: 16, design: .serif))
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                .padding(.top, 12)
                                .padding(.bottom, 12)
                                .frame(alignment: .center)
                        
                            
                            if homeManager.hasUserCheckedInToday == false {
                                Button(action: {
                                    print("User wanted to check in")
                                    homeManager.isCheckInPopupShowing = true
                                }) {
                                    Text("Fill in daily status")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .background(Color("SoftCoral"))
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                        .padding(.horizontal, 20)
                                }
                                .sheet(isPresented: $homeManager.isCheckInPopupShowing) {
                                    CheckInView()
                                        .onDisappear {
                                            if let user = Auth.auth().currentUser?.uid {
                                                homeManager.userInit(userID: user)
                                            } else {
                                                print("no user yet")
                                            }
                                        }
                                }
                                .foregroundColor(.white)
                                .padding(.bottom, 12)
                            }
                            
                            // Goals
                            HStack {
                                Text("Goals")
                                    .bold()
                                    .font(.system(size: 22, design: .serif))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                if homeManager.lastCheckInDate != "" {
                                    Text("Set \(homeManager.lastCheckInDate)")
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundColor(.black)
                                }
                                
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            
                            
                            // Goals
                            VStack(alignment: .center) {
                                // Goal one
                                GoalView(goalText: homeManager.todaysCheckIn!.goals![0], goalHue: 1.0, goalSaturation: 0.111)
                                
                                // Goal two
                                GoalView(goalText: homeManager.todaysCheckIn!.goals![1], goalHue: 0.797, goalSaturation: 0.111)
                                
                                // Goal three
                                GoalView(goalText: homeManager.todaysCheckIn!.goals![2], goalHue: 0.542, goalSaturation: 0.226)
                            }
                            .padding(.bottom, 20)
                            
                            
                            // Gratitude
                            VStack {
                                
                                HStack {
                                    Text("Gratitude")
                                        .bold()
                                        .font(.system(size: 22, design: .serif))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                
                                
                                
                                Text(homeManager.todaysCheckIn!.gratitude!)
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundColor(.black)
                                    .italic()
                                    .padding(.top, 10)
                            }
                            .padding(.leading, 20)
                            
                            
                            ActivitiesModule(isPremiumUser: self.profileStateManager.userProfile?.isPremiumUser ?? false)
                                .padding(.bottom, 40)
                            
                            
                            EducationModule(isPremiumUser: self.profileStateManager.userProfile?.isPremiumUser ?? false)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top, 6)
            }
            .onAppear {
                if let user = Auth.auth().currentUser?.uid {
                    homeManager.userInit(userID: user)
                } else {
                    print("from home view: no user yet")
                }
                
                print("has user checked in: \(homeManager.hasUserCheckedInToday)")
            }
            .environmentObject(homeManager)
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}


struct GoalView: View {
    let goalText: String?
    
    let goalHue: CGFloat?
    let goalSaturation: CGFloat?
    
    @State var goalComplete = false
    
    var body: some View {
        Button(action: {
            print("goal complete")
            goalComplete = !goalComplete
        }) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hue: goalHue!, saturation: goalSaturation!, brightness: 1.0))
                .frame(width: 360, height: 70, alignment: .leading)
                .overlay {
                    VStack() {
                        if goalComplete {
                            Text(goalText!)
                                .foregroundColor(.green)
                                .font(.system(size: 16, design: .serif))
                        }
                        else {
                            Text(goalText!)
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                    
                    if goalComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 26, alignment: .leading)
                            .foregroundColor(.green)
                            .offset(x: 175, y: -38)
                    }
                }
        }
        
        
    }
}


struct ActivitiesModule: View {
    var activities = ["Quiz1", "Quiz2", "Quiz3"]
    var isPremiumUser: Bool?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Activities")
                    .foregroundColor(.black)
                    .font(.system(size: 22, design: .serif))
                    .bold()
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    CharacterAchetypeView()
                    JournalingPromptsActivityView()
                    HealthyRelationshipActivityView()
                }
            }
            
        }
        .padding(.leading, 20)
    }
}


struct EducationModule: View {
    var isPremiumUser: Bool?
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Education")
                    .foregroundColor(.black)
                    .font(.system(size: 22, design: .serif))
                    .bold()
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let premium = isPremiumUser {
                        if premium == false {
                            ThinkingErrorsView()
                            ImpulsivityView()
                            LockedActivityEducationView()
                        } else {
                            ThinkingErrorsView()
                            ImpulsivityView()
                            StagesOfGriefView()
                        }
                    } else {
                        ThinkingErrorsView()
                        ImpulsivityView()
                        StagesOfGriefView()
                    }
                }
            }
        }
        .padding(.leading, 20)
    }
}

struct LockedActivityEducationView: View {
    var body: some View {
        // BG
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25)
                .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                .foregroundColor(.blue)
                .overlay {
                    ZStack {
                        Image("lock")
                            .resizable()
                            .cornerRadius(25)
                    }
                }
            
            Text("Premium users enjoy more \nactivities and education pieces.")
                .foregroundColor(.black)
                .font(.system(size: 16, design: .serif))
        }
        
    }
}
