//
//  StagesOfGriefView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 09/02/25.
//

import SwiftUI

struct StagesOfGriefView: View {
    var body: some View {
        NavigationLink(destination: StagesOfGriefInfoView()) {
            // BG
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("Grief_BG")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
                Text("The Stages of Grief")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
                Text("4 min")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
            }
        }
    }
}

struct StagesOfGriefView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}


struct StagesOfGriefInfoView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                HStack {
                    Text("The Stages of Grief")
                        .font(.system(size: 30, design: .serif))
                        .bold()
                        .padding(20)
                        .offset(y: -100)
                    
                    Spacer()
                }
                
                Text("Grief is a natural and normal human response to loss. It is a process that everyone goes through, and one which is important to be aware of its mind altering affects. There is no right or wrong way to grieve, the process is dynamic and different for everyone. There are five core stages to grief, the stages are non-linear, and vary greatly for each person.")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                
                
                
                NavigationLink(destination: StagesOfGriefDetailedView()) {
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


struct StagesOfGriefDetailedView: View {
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView {
                    // Denial
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "eye.slash")
                                .resizable()
                                .frame(width: 40, height: 30)
                            
                            Text("Denial")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("The refusal to accept the recent loss. Those in denial may behave as if the loss has not occurred, and refuse to discuss it or picture it.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Synonyms: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- Shock")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Numbness")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Confusion")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Shutting down")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        Text("Denial is a common defense mechanism, and we shouldn't feel guilty about being in denial. This stage of grief can lead to procrastination, being distracted easily and impulsive behavior.")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Anger
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "shared.with.you.slash")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Anger")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("The rage, resentment, and bitterness that comes with a recent loss. Those in this stage of grief are frustrated by the loss, and are often easily irritated and may act in a volatile manner.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Synonyms: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- Frustration")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Impatience")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Resentment")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        Text("Anger is a natural human reaction, especially to things out of our control. Those basking in anger are often masking their pain with their aggresive behavior. This stage is dangerous as it causes us to lash out, get in arguments, and in the worst case turn to substances to ease the pain.")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Bargaining
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Bargaining")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("The desire to make a deal with the universe to either reverse the loss or make ammends for the loss in some way. People in this stage have trouble with the reality of the situation, and believe that they can somehow make things right.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Synonyms: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- Guilt")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Shame")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Blame")
                            .font(.system(size: 20, design: .serif))
                        Text("- Insecurity")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        Text("While bargaining, one is often stuck ruminating on the past, often in a state of delusion that they could have changed things. One often worries obsessively about the future, judging themselves for not making things right.")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Depression
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.and.background.dotted")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Depression")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("The state of sadness, hopelessness and despair that follows the loss. In this stage, often one has fully realized the loss, often struggling with the permanence of its impact.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Synonyms: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- Sadness")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Despair")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Helpless")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        Text("Depression brings many side effects with it, including reduced energy, reduced apetite, withrawl from social life, trouble sleeping, and low motivation. This is often the hardest stage of grief seeing as depression is an extremely strong force to battle.")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Acceptance
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "figure.wave.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Acceptance")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("The final stage of grief, where one finally comes to terms with the loss and the reality of the impact of change. Those in this stage still feel the effects and sadness of the loss, but have begun to return the normal state of life.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Synonyms: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- Courage")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Pride")
                            .font(.system(size: 20, design: .serif))
                        
                        Text("- Validation")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        Text("Only after one has begun to accept the loss can they return to reality. Awareness returns to those accepting the reality of the loss, often understanding their own vulnerability and adapting to life after loss.")
                            .font(.system(size: 20, design: .serif))
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
