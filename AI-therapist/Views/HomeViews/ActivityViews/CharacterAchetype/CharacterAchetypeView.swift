//
//  CharacterAchetypeView.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/30/23.
//

// testing the commit

import SwiftUI

struct CharacterAchetypeView: View {
    var body: some View {
        NavigationLink(destination: CharacterArchetypeInfoView()) {
            // BG
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("CA_BG2")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
                Text("Character Archetype Quiz")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
                Text("6 min")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
            }
            
        }
    }
}

struct CharacterAchetypeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
            .environmentObject(CharacterArchetypeManager())
    }
}


struct CharacterArchetypeInfoView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Characer Archetype Quiz")
                    .font(.system(size: 30, design: .serif))
                    .bold()
                    .padding(20)
                    .offset(y: -100)
                
                Text("Answer the following 36 questions on a scale from 1 to 5. 1 being strongly disagree and 5 being strongly agree. Based on your results we will let you know which character archetypes you most closely represent.")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                
                
                
                NavigationLink(destination: CharacterArchetypeDetailedView()) {
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


struct CAQuestion: View {
    @Binding var sliderValue: Double
    
    let questionText: String
    
    var body: some View {
        ZStack {
            
            VStack {
                Text(questionText)
                    .font(.system(size: 20, design: .serif))
                
                Slider(
                    value: $sliderValue,
                    in: 1...5,
                    step: 1
                ) {
                    Text("Value: \(sliderValue)")
                }
            }
            
            HStack {
                Text("1")
                    .padding(.trailing, 100)
                Text("5")
                    .padding(.leading, 200)
            }
            .offset(y: 60)
        }
        .padding(.bottom, 40)
    }
}

struct CharacterArchetypeDetailedView: View {
    
    @StateObject var characterArchetypeManager = CharacterArchetypeManager()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                ScrollView {
                    // TBD
                    VStack {
                        // Column 1 -> Column 3
                        VStack {
                            // Q1 - Column 1
                            CAQuestion(sliderValue: $characterArchetypeManager.q1SliderVal, questionText: "I assume that people I meet are trustworthy")
                            
                            // Q2 - Column  2
                            CAQuestion(sliderValue: $characterArchetypeManager.q2SliderVal, questionText: "I am concerned by how I was hurt as a child")

                            // Q3 - Column 3
                            CAQuestion(sliderValue: $characterArchetypeManager.q3SliderVal, questionText: "I am willing to take personal risks to defend my beliefs")

                            // Q4 - Column 1
                            CAQuestion(sliderValue: $characterArchetypeManager.q4SliderVal, questionText: "I believe that people don't really mean to hurt each other")
                            
                            // Q5 - Column 2
                            CAQuestion(sliderValue: $characterArchetypeManager.q5SliderVal, questionText: "Others take advantage of me")
                            
                            // Q6 - Column 3
                            CAQuestion(sliderValue: $characterArchetypeManager.q6SliderVal, questionText: "I put aside fear and do what needs to be done")
                            
                            // Q7 - Column 1
                            CAQuestion(sliderValue: $characterArchetypeManager.q7SliderVal, questionText: "I can count on others to take care of me")
                            
                            // Q8 - Column 2
                            CAQuestion(sliderValue: $characterArchetypeManager.q8SliderVal, questionText: "I find it is hard to get motivated")
                            
                            // Q9 - Column 3
                            CAQuestion(sliderValue: $characterArchetypeManager.q9SliderVal, questionText: "Competition brings out my best efforts")
                        }
                        // Column 4 -> Column 6
                        VStack {
                            // Q10 - Column 4
                            CAQuestion(sliderValue: $characterArchetypeManager.q10SliderVal, questionText: "I find it easier to do for others than to do for myself")
                            
                            // Q11 - Column 5
                            CAQuestion(sliderValue: $characterArchetypeManager.q11SliderVal, questionText: "I am looking for greener pastures")
                            
                            // Q12 - Column 6
                            CAQuestion(sliderValue: $characterArchetypeManager.q12SliderVal, questionText: "I find fulfillment through relationships")
                            
                            // Q13 - Column 4
                            CAQuestion(sliderValue: $characterArchetypeManager.q13SliderVal, questionText: "I find satisfaction caring for others")
                            
                            // Q14 - Column 5
                            CAQuestion(sliderValue: $characterArchetypeManager.q14SliderVal, questionText: "I am searching for ways to improve myself")
                            
                            // Q15 - Column 6
                            CAQuestion(sliderValue: $characterArchetypeManager.q15SliderVal, questionText: "Intimacy is a priority for me")
                            
                            // Q16 - Column 4
                            CAQuestion(sliderValue: $characterArchetypeManager.q16SliderVal, questionText: "Kindness is a primary value for me")
                            
                            // Q17 - Column 5
                            CAQuestion(sliderValue: $characterArchetypeManager.q17SliderVal, questionText: "I am exploring new possibilities")
                            
                            // Q18 - Column 6
                            CAQuestion(sliderValue: $characterArchetypeManager.q18SliderVal, questionText: "I feel more complete when I am in love")
                        }
                        // Column 7 -> Column 9
                        VStack {
                            // Q19 - Column 7
                            CAQuestion(sliderValue: $characterArchetypeManager.q19SliderVal, questionText: "There is an emptiness in my life")
                            
                            // Q20 - Column 8
                            CAQuestion(sliderValue: $characterArchetypeManager.q20SliderVal, questionText: "I have a lot more great ideas than I have time to act on them")
                            
                            // Q21 - Column 9
                            CAQuestion(sliderValue: $characterArchetypeManager.q21SliderVal, questionText: "I am good at matching people's abilities with tasks to be done")
                            
                            // Q22 - Column 7
                            CAQuestion(sliderValue: $characterArchetypeManager.q22SliderVal, questionText: "I feel bewildered by so much change in my life")
                            
                            // Q23 - Column 8
                            CAQuestion(sliderValue: $characterArchetypeManager.q23SliderVal, questionText: "I have times of high accomplishment that feel effortless to me")
                            
                            // Q24 - Column 9
                            CAQuestion(sliderValue: $characterArchetypeManager.q24SliderVal, questionText: "I prefer to be in charge")
                            
                            // Q25 - Column 7
                            CAQuestion(sliderValue: $characterArchetypeManager.q25SliderVal, questionText: "Recent experiences have caused me to rethink who I am")
                            
                            // Q26 - Column 8
                            CAQuestion(sliderValue: $characterArchetypeManager.q26SliderVal, questionText: "People see me as a creative person")
                            
                            // Q27 - Column 9
                            CAQuestion(sliderValue: $characterArchetypeManager.q27SliderVal, questionText: "I have a duty to meet my obligations")
                        }
                        // Column 10 - Column 12
                        VStack {
                            // Q28 - Column 10
                            CAQuestion(sliderValue: $characterArchetypeManager.q28SliderVal, questionText: "Changing my inner thoughts changes my outer life")
                            
                            // Q29 - Column 11
                            CAQuestion(sliderValue: $characterArchetypeManager.q29SliderVal, questionText: "I believe there are many good ways to look at the same thing")
                            
                            // Q30 - Column 12
                            CAQuestion(sliderValue: $characterArchetypeManager.q30SliderVal, questionText: "I like to 'lighten up' people who are too serious")
                            
                            // Q31 - Column 10
                            CAQuestion(sliderValue: $characterArchetypeManager.q31SliderVal, questionText: "I believe everyone and everything in the world are interconnected")
                            
                            // Q32 - Column 11
                            CAQuestion(sliderValue: $characterArchetypeManager.q32SliderVal, questionText: "I try to find thruth behind illusions")
                            
                            // Q33 - Column 12
                            CAQuestion(sliderValue: $characterArchetypeManager.q33SliderVal, questionText: "I laugh at the absurdity of life")
                            
                            // Q34 - Column 10
                            CAQuestion(sliderValue: $characterArchetypeManager.q34SliderVal, questionText: "The process of my own self-healing enables me to help heal others")
                            
                            // Q35 - Column 11
                            CAQuestion(sliderValue: $characterArchetypeManager.q35SliderVal, questionText: "I like challenges that really make me think")
                            
                            // Q36 - Column 12
                            CAQuestion(sliderValue: $characterArchetypeManager.q36SliderVal, questionText: "There is nothing better than a good laugh")
                        }
                        
//                        NavigationLink(destination: CharacterArchetypeResultsView()) {
//                            Text("Finish")
//                        }
//                        .onTapGesture(perform: {
//                            characterArchetypeManager.calculateArchetypes()
//                            print("cap probably")
//                        })
                        
                        Button(action: {
                            print("not cap god damn")
                            characterArchetypeManager.isResultsPopupShowing = true
                            characterArchetypeManager.calculateArchetypes()
                        }) {
                            Text("Finish")
                        }.sheet(isPresented: $characterArchetypeManager.isResultsPopupShowing) {
                            ZStack {
                                
                                Image(characterArchetypeManager.background)
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)

                                
                                
                                VStack(alignment: .leading) {
                                    Text("Your top three character types are: ")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, design: .serif))
                                        .padding(.bottom, 40)
                                    
                                    Text("1. The \(characterArchetypeManager.oneArchetype)")
                                        .font(.system(size: 22, design: .serif))
                                        .foregroundColor(.white)
                                    Text(characterArchetypeManager.oneDescription)
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundColor(.white)
//                                        .padding(.leading, 40)
//                                        .padding(. trailing, 40)
                                        .padding(.bottom, 40)
                                        
                                    
                                    Text("2. The \(characterArchetypeManager.twoArchetype)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 22, design: .serif))
                                    Text(characterArchetypeManager.twoDescription)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, design: .serif))
//                                        .padding(.leading, 40)
//                                        .padding(. trailing, 40)
                                        .padding(.bottom, 40)
                                        

                                    
                                    Text("3. The \(characterArchetypeManager.threeArchetype)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 22, design: .serif))
                                    Text(characterArchetypeManager.threeDescription)
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundColor(.white)
//                                        .padding(.leading, 40)
//                                        .padding(. trailing, 40)
                                        .padding(.bottom, 40)
                                }
                                .padding(.top, 100)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
//                                .edgesIgnoringSafeArea(.all)
                                .onDisappear {
                                    characterArchetypeManager.isResultsPopupShowing = false
                                }
                            }
//                            .edgesIgnoringSafeArea(.all)
                        }
//                        .edgesIgnoringSafeArea(.all)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
        .environmentObject(characterArchetypeManager)
    }
}



//struct CharacterArchetypeResultsView: View {
//    @EnvironmentObject var characterArchetypeManager: CharacterArchetypeManager
//    var body: some View {
//
//
////        .onAppear {
////            characterArchetypeManager.calculateArchetypes()
////        }
//    }
//}
