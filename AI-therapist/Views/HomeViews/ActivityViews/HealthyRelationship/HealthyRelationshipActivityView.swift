//
//  HealthyRelationshipActivityView.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/4/23.
//

import SwiftUI

struct HealthyRelationshipActivityView: View {
    var body: some View {
        NavigationLink(destination: HealthyRelationshipInfoView()) {
            // BG
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("HealthyRelationship_BG")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
                Text("Healthy Relationship Quiz")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
                Text("4 min")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
            }
            
        }
    }
}

struct HealthyRelationshipActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
            .environmentObject(HealthyRelationshipManager())
    }
}


struct HealthyRelationshipInfoView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Healthy Relationship Quiz")
                    .font(.system(size: 30, design: .serif))
                    .bold()
                    .padding(20)
                    .offset(y: -100)
                
                Text("Everyone deserves to be in a healthy and happy relationship. This quiz should shed some light on the healthy and not-so healthy aspects of your relationship. Please note this quiz is for educational purposes only!")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                
                
                
                NavigationLink(destination: HealthyRelationshipDetailedView()) {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                        .overlay {
                            ZStack {
                                Text("Begin")
                                    .foregroundColor(.black)
                                    .font(.system(size: 15, design: .monospaced))
                            }
                        }
                }
            }
        }
    }
}

struct HealthyRelationshipDetailedView: View {
    
    @StateObject var healthyRelationshipManager = HealthyRelationshipManager()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("The person I'm with")
                    .font(.system(size: 18, design: .serif))
                    .padding(.bottom, 40)
                
                ScrollView {
                    
                    
                    // Q 1-9
                    VStack {
                        HRQuizQuestion(text: "Is very supportive of things that I do.", questionNumber: 0)
                        
                        HRQuizQuestion(text: "Encourages me to try new things.", questionNumber: 1)
                        
                        HRQuizQuestion(text: "Likes to listen when I have something on my mind.", questionNumber: 2)
                        
                        HRQuizQuestion(text: "Understands that I have my own life too.", questionNumber: 3)
                        
                        HRQuizQuestion(text: "Is not liked very well by my friends", questionNumber: 4)
                        
                        HRQuizQuestion(text: "Says I'm too involved in different activities.", questionNumber: 5)
                        
                        HRQuizQuestion(text: "Texts me or calls me all the time.", questionNumber: 6)
                        
                        HRQuizQuestion(text: "Thinks I spend too much time trying to look nice.", questionNumber: 7)
                        
                        HRQuizQuestion(text: "Gets extremely jealous or possessive.", questionNumber: 8)
                    }
                    // Q 10-18
                    VStack {
                        HRQuizQuestion(text: "Accuses me of flirting or cheating.", questionNumber: 9)
                        
                        HRQuizQuestion(text: "Constantly checks up on me or makes me check in.", questionNumber: 10)
                        
                        HRQuizQuestion(text: "Controls what I wear or how I look.", questionNumber: 11)
                        
                        HRQuizQuestion(text: "Tries to control what I do and who I see.", questionNumber: 12)
                        
                        HRQuizQuestion(text: "Tries to keep me from seeing or talking to family and friends.", questionNumber: 13)
                        
                        HRQuizQuestion(text: "Has big mood swings, getting angry and yelling at me one minute but being sweet and apologetic the next.", questionNumber: 14)
                        
                        HRQuizQuestion(text: "Makes me feel nervous or like I'm 'walking on eggshells'.", questionNumber: 15)
                        
                        HRQuizQuestion(text: "Puts me down, calls me names or criticizes me.", questionNumber: 16)
                        
                        HRQuizQuestion(text: "Makes me feel like I can't do anything right or blames me for problems..", questionNumber: 17)
                    }
                    // Q 19 - 26
                    VStack {
                        HRQuizQuestion(text: "Makes me feel like no one else would want me.", questionNumber: 18)
                        
                        HRQuizQuestion(text: "Threatens to hurt themselves because of me", questionNumber: 19)
                        
                        HRQuizQuestion(text: "Threatens to destroy my things.", questionNumber: 20)
                        
                        HRQuizQuestion(text: "Grabs, pushes, shoves, chokes, punches slaps, or hurts me in some way.", questionNumber: 21)
                        
                        HRQuizQuestion(text: "Breaks or throws things to intimidate me.", questionNumber: 22)
                        
                        HRQuizQuestion(text: "Yells, screams or humiliates me in front of other people.", questionNumber: 23)
                        
                        HRQuizQuestion(text: "Pressures or forces me into having sex or going farther than I want to.", questionNumber: 24)
                    }
                    .padding(.bottom, 40)
                    
                    Button(action: {
                        healthyRelationshipManager.calculateResult()
                        healthyRelationshipManager.isResultsPopupShowing = true
                    }) {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
                            .overlay {
                                ZStack {
                                    Text("Finish")
                                        .foregroundColor(.black)
                                        .font(.system(size: 15, design: .monospaced))
                                }
                            }
//                        Text("Finish")
                    }.sheet(isPresented: $healthyRelationshipManager.isResultsPopupShowing) {
                        ZStack {
                            VStack {
                                if healthyRelationshipManager.result == 0 {
                                    Text("Your relationship sounds like it is on a healthy track! Maintaining a healthy relationship is a lot of work, keep it up! Remember to respect your partner and never forget they're human too.")
                                        .font(.system(size: 18, design: .serif))
                                }
                                
                                if healthyRelationshipManager.result == 1 {
                                    Text("You might be noticing a couple of things in your relationship that are unhealthy, but it doens't necessarily mean they are warning signs. It's still a good idea to keep an eye out and make sure there isn't an unhealthy pattern developing. The best thing you can do is talk to your partner and make sure you're on the same page about aspects of the relationship that are and aren't going well.")
                                        .font(.system(size: 18, design: .serif))
                                }
                                
                                if healthyRelationshipManager.result == 2 {
                                    Text("It sounds like you might be seeing some warning signs of an abusive relationship. Don't ignore these red flags. something that starts small can grow to be much worse over time if neglected. No relationship is perfect, it takes work! Remember to be open and honest with your partner about how to grow together.")
                                        .font(.system(size: 18, design: .serif))
                                }
                                
                                if healthyRelationshipManager.result == 3 {
                                    Text("You are definitely seeing warning signs and may be in an abusive relationship. Remember the most important thing is safety. Consider making yourself a safety plan. If you need help reach out to your loved ones and explain to your partner why you feel abused or unsafe in the relationship.")
                                        .font(.system(size: 18, design: .serif))
                                }
                                
//                                Button(action: {
//                                    
//                                }) {
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .frame(maxWidth: 300, minHeight: 50, maxHeight: 50)
//                                        .overlay {
//                                            ZStack {
//                                                Text("Close Quiz")
//                                                    .foregroundColor(.black)
//                                                    .font(.system(size: 15, design: .monospaced))
//                                            }
//                                        }
//                                }
//                                .padding(.top, 40)
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            
                        }.onDisappear {
                            healthyRelationshipManager.isResultsPopupShowing = false
                        }
                    }
                    
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                
            }
        }
        .environmentObject(healthyRelationshipManager)
        
    }
}

struct HRQuizQuestion: View {
    
    @EnvironmentObject var healthyRelationshipManager: HealthyRelationshipManager
    
    let text: String?
    // Whether or not the user answered yes to the question
    @State var isYesSelected: Bool?
    @State var isNoSelected: Bool?
    
    let questionNumber: Int
    
    var body: some View {
        
        HStack {
            Text(text ?? "q")
                .font(.system(size: 18, design: .serif))
            
            Spacer()
            
            Group {
                // Yes
                if let isYes = isYesSelected {
                    if isYes == true {
                        Button(action: {
                            healthyRelationshipManager.questionScores[self.questionNumber] = 1
                        }) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                        }
                    } else {
                        Button(action: {
                            self.isYesSelected = true
                            self.isNoSelected = false
                            
                            healthyRelationshipManager.questionScores[self.questionNumber] = 1
                        }) {
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                        }
                    }
                } else {
                    Button(action: {
                        self.isYesSelected = true
                        self.isNoSelected = false
                        
                        healthyRelationshipManager.questionScores[self.questionNumber] = 1
                    }) {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                
                
                
                //  No
                if let isNo = isNoSelected {
                    if isNo == true {
                        Button(action: {
                            healthyRelationshipManager.questionScores[self.questionNumber] = 0
                        }) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    } else {
                        Button(action: {
                            self.isNoSelected = true
                            self.isYesSelected = false
                            
                            healthyRelationshipManager.questionScores[self.questionNumber] = 0
                        }) {
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    Button(action: {
                        self.isNoSelected = true
                        self.isYesSelected = false
                        
                        healthyRelationshipManager.questionScores[self.questionNumber] = 0
                    }) {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.5))
        .padding(.leading, 20)
        .padding(.trailing, 20)
        
        
        
    }
}


struct HealthyRelationshipResultsView: View {
    @EnvironmentObject var healthyRelationshipManager: HealthyRelationshipManager
    var body: some View {
        
        ZStack {
            Text("heres ur results ho")
            
            Button(action: {
                
            }) {
                Text("Close quiz")
            }
        }.onAppear {
            healthyRelationshipManager.calculateResult()
        }
    }
}
