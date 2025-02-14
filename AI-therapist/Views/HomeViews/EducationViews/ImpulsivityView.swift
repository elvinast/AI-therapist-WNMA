//
//  ImpulsivityView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 07/02/25.
//

import SwiftUI

struct ImpulsivityView: View {
    var body: some View {
        NavigationLink(destination: ImpulsivityInfoView()) {
            // BG
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("Impulsivity_BG")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
                Text("Coping with Impulsivity")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
                Text("2 min")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
            }
        }
    }
}

struct ImpulsivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}

struct ImpulsivityInfoView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                HStack {
                    Text("Coping with Impulsivity")
                        .font(.system(size: 30, design: .serif))
                        .bold()
                        .padding(20)
                        .offset(y: -100)
                    
                    Spacer()
                }
                
                Text("Impulsivity involves a tendency to act on a whim, displaying behavior characterized by little or no forethought, reflection, or consideration of the consequences. The ability to regulate impuslivity, known as impulse control, is defined as the degree to which a person can control the desire for immediate gratification.")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                
                
                
                NavigationLink(destination: ImpulsivityDetailedView()) {
                    Text("Begin")
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
            }
        }
    }
}


struct ImpulsivityDetailedView: View {
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    // Overview
                    VStack(alignment: .leading) {
                        Text("The Problem")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        
                        Text("If you have a problem with impulsiveness, then you may often speak or act without thinking and at times you may end up facing the consequences of acting quickly and irrationally. Taking the time to think before acting is often times the difference between a good decision and a bad decision.")
                            .font(.system(size: 18, design: .serif))
                            .padding(.bottom, 10)
                    }
                    .padding(.bottom, 40)
                    // Coping skills
                    VStack(alignment: .leading) {
                        Text("Coping Skills for Managing Impulsiveness")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                            .padding(.bottom, 10)
                        
                        Group {
                            Text("1. Remember")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("When you mess up and make an impulsive decision, try to remember and hold on to that feeling. It's important not to forget or bury these negative feelings and memories associated with impulsivity. Often times we choose to forget the consequences which occurred from our impulsive decisions, this only makes it that much more difficult to avoiding being impulsive in the future.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        Group {
                            Text("2. Practice Time Outs")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("Take time to practice waiting before speaking or acting. Count to 10, imagine a big red STOP sign in front of you, do what you need to do in order to make a regular habit of stopping to wait and think before jumping into an impulsive decision, especially one which you might regret later.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        
                        Group {
                            Text("3. Deny Yourself")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("Learn the special art of simply saying 'no' to yourself. Practice delayed gratification. The ability to resist the temptation for an immediate reward and wait for a later reward.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        Group {
                            Text("4. Sleep On It")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("Quite often you may feel very different and much more level-headed in the morning if you can just wait it out over a decent night's sleep before making a decision.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        Group {
                            Text("5. Recognize Emotional Reactions")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("When you are about to do something you may regret, first get in the practice of asking yourself: 'Am I making this decision because of my emotions?' If the answer is 'Yes' then you are better off waiting and thinking rationally about the choice before making it.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        Group {
                            Text("6. Phone a Friend")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("Call a friend before you do something regrettable or stupid. Isn't that what friends are for? (Make sure it's a reliable friend and not one who feeds into your impulsivity)")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        Group {
                            Text("7. Spirituality")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("If you believe in something greater than yourself, use that to your advantage when it comes to managing your impulses.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        Group {
                            Text("8. Know Your Triggers and Prepare")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("If you know that there are certain people, places, or things that set you off, than avoid those things. If you can't avoid them, then prepare and be ready for facing those things ahead of time. Bring a friend if it's going to be really tough for you.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                            
                            Text("9. Mind your Mind")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("During calm moments in your life, try to really get to know yourself and what stresses you out or gets you upset, anxious or excited. Know and understand what feelings set you off when it comes to impulsive decision making. Practicing this over time allows you to build your emotional regulation.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                            
                            Text("10. Relax")
                                .font(.system(size: 18, design: .serif))
                                .bold()
                            
                            Text("Even if just a little, if you can learn to calm yourself, you are much less likely to make an impulsive move when you are more relaxed. It's easier to be patient when you're relaxed and patience is essential when it comes to impulse control.")
                                .font(.system(size: 18, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                    }
                    .padding(.bottom, 40)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}
