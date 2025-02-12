//
//  JournalingPromptsActivityView.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/5/23.
//

import SwiftUI

struct JournalingPromptsActivityView: View {
    var body: some View {
        NavigationLink(destination: JournalingPromptsInfoView()) {
            // BG
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("JournalingPrompts_BG")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
                Text("Journaling Prompts")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
                Text("2 min")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
            }
            
        }
    }
}

struct JournalingPromptsActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}


struct JournalingPromptsInfoView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Journaling Prompts")
                    .font(.system(size: 30, design: .serif))
                    .bold()
                    .padding(20)
                    .offset(y: -100)
                
                Text("Use these prompts to inspire a commitment to regular writing and journaling as a relfection tool and spirutal exercise. Grab a pen and paper and get your thoughts out in a healthy and practical way. Don't forget to share your responses and feedback in the community forum!")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                
                
                
                NavigationLink(destination: JournalingPromptsDetailedView()) {
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

struct JournalingPromptsDetailedView: View {
    var body: some View {
        ZStack {
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        Text("1. What part of your life are you the most grateful for? What things would you not be where you are in lift without?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("2. What does spirituality mean to you? Where did you learn this and what factor does this play in your life?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("3. What would need to change in today's world for things to be better? What can you and others do to make this change a reality?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("4. What do you think happens when we die?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("5. Do you believe human beings have souls? Why or why not?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("6. If you could ask your future self one question, what would it be?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("7. If you could give your younger self what would it be and why?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("8. What people, ideas, or art has influenced your life for the better? How have you been impacted by these things?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("9. Write about the time in your life you have felt the most connected to your spirituality.")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("10. Do you have any recurring dreams? What do you think they mean?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                    }
                    VStack (alignment: .leading){
                        Text("11. Do you believe in a higher power? What do you think is the reason life exists?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("12. Do you think all living things are connected in some way? If so how?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                        
                        Text("13. What's the most important part of your life that keeps you happy and healthy?")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                    }
                }
            }
            .padding(.top, 40)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    }
}
