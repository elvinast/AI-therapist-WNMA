//
//  ThinkingErrorsView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 20/01/25.
//

import SwiftUI

struct ThinkingErrorsView: View {
    var body: some View {
        NavigationLink(destination: ThinkingErrorsInfoView()) {
            // BG
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("ThinkingErrors_BG")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
                
                Text("Thinking Errors")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
                Text("3 min")
                    .foregroundColor(.black)
                    .font(.system(size: 16, design: .serif))
            }
            
        }
    }
}

struct ThinkingErrorsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}

struct ThinkingErrorsInfoView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                HStack {
                    Text("Thinking Errors")
                        .font(.system(size: 30, design: .serif))
                        .bold()
                        .padding(20)
                        .offset(y: -100)
                    Spacer()
                }
                
                Text("Thinking errors, also known as cognitive distoritions, are a type of mental shortcut that can lead to faulty thinking. They can be caused by a variety of factors including stress, anxiety and depression. Please take a look at the following thinking errors and see where they show up in your life.")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                
                
                
                NavigationLink(destination: ThinkingErrorsDetailedView()) {
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

struct ThinkingErrorsDetailedView: View {
    var body: some View {
        ZStack {
            VStack {
                
                ScrollView {
                    // Mind Reading
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Mind Reading")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("Believing you know what someone else is thinking, or why they are doing something, without having enough information.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Examples: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- ''People are looking at me. They all know I didn't brush my teeth this morning''.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        
                        Text("- ''Emma didn't invite me to her birthday party, she must think I'm so weird.''")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Negative Labeling
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "tag.slash")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Negative Labeling")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("Having a negative belief about yourself and thinking it applies to everything you do.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Examples: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- ''I think I'm a loser, so there's no way I could ever make great art''.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        
                        Text("- ''I'm really dumb, everything I say is so stupid.''")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Setting the Bar Too High
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "trophy")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Setting the Bar Too High")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("Thinking that you must be perfect in everything you do, otherwise you're no good.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Examples: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- ''If I don't get an A on every test, I'm not smart.''.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        
                        Text("- ''I have to win every tennis match I ply, otherwise I'm worthless.''")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Self Blaming
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "hand.point.right")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Self Blaming")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("Blaming yourself for anything that goes wrong around you, even if you had nothing to do with it.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Examples: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- When your basketball team loses a game, you think it's entirely your fault.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        
                        Text("- ''Alicia is sad today. I probably did something to upset her.''")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // Feelings as Facts
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("Feelings as Facts")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("Believing that if you feel something, it must be true.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Examples: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("- ''I feel ugly, so I must be ugly''.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        
                        Text("- ''I feel like I'm a bad friend, so I must be a bad friend''")
                            .font(.system(size: 20, design: .serif))
                    }
                    .padding(.bottom, 40)
                    // "Should" Statements
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "xmark.seal")
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                            Text("''Should'' Statements")
                                .font(.system(size: 20, design: .serif))
                                .bold()
                        }
                        Text("Believing things have to be a certain way.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 10)
                        Text("Examples: ")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                        Text("''People should always be nice to me''.")
                            .font(.system(size: 20, design: .serif))
                            .padding(.bottom, 5)
                        
                        Text("- ''I should always be happy. I should never be sad.''")
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
