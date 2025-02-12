//
//  ForumCategoriesView.swift
//  AI-therapist
//
//  Created by Viiktoria Voevodina on 10/01/25.
//

import SwiftUI

struct ForumCategoriesView: View {
    var body: some View {
        
        ZStack {
            
            VStack {
                
                // This is the scroll view.
                ScrollView {
                    // Tab to switch to chat
                    
                    
                    VStack(alignment: .leading) {
                        // General
                        NavigationLink(destination: ForumDetailedView(title: "General")) {
                            ListItem(icon: "person.2.circle", title: "General", description: "Anything and everything related to life and health.")
                        }
                        
                        
                        // Depression
                        NavigationLink(destination: ForumDetailedView(title: "Depression")) {
                            ListItem(icon: "brain.head.profile", title: "Depression", description: "Symptoms, causes, treatments, tips and other discussions related to depression.")
                        }
                        
                        // Stress and Anxiety
                        NavigationLink(destination: ForumDetailedView(title: "Stress and Anxiety")) {
                            ListItem(icon: "bubbles.and.sparkles", title: "Stress and Anxiety", description: "Information, stories, advice, causes, treatments and discussions related to stress and anxiety.")
                        }
                        
                        
                        
                        // Relationships
                        NavigationLink(destination: ForumDetailedView(title: "Relationships")) {
                            ListItem(icon: "person.2.wave.2", title: "Relationships", description: "Highs, lows, details and questions relating to your relationships.")
                        }
                        
                        // Recovery
                        NavigationLink(destination: ForumDetailedView(title: "Recovery")) {
                            ListItem(icon: "microbe", title: "Recovery", description: "Discussions related to those going through the recovery process.")
                        }
                        
                        // Addiction
                        NavigationLink(destination: ForumDetailedView(title: "Addiction")) {
                            ListItem(icon: "pills", title: "Addiction", description: "Questions, advice, treatments and personal advice for those currently or previosuly facing addiction.")
                        }
                        
                        // Sobriety
                        NavigationLink(destination: ForumDetailedView(title: "Sobriety")) {
                            ListItem(icon: "aqi.medium", title: "Sobriety", description: "Stories, advice and motivation for reaching sobriety and living sober.")
                        }
                        
                        // Personal Stories
                        NavigationLink(destination: ForumDetailedView(title: "Personal Stories")) {
                            ListItem(icon: "quote.bubble", title: "Personal Stories", description: "A place to share your personal stories which could be helpful to others.")
                        }
                        
                        // Advice
                        NavigationLink(destination: ForumDetailedView(title: "Advice")) {
                            ListItem(icon: "person.crop.rectangle.stack", title: "Advice", description: "A forum to ask for advice relating to life and health.")
                        }
                    }
                    //                        .frame(alignment: .leading)
                    //                        .padding(.trailing, 100)
                    
                    
                }.padding(.top, 20)
            }
        }
        .background(Color.clear)
        
    }
}

struct ForumCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ForumCategoriesView()
    }
}


struct ListItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .fixedSize(horizontal: true, vertical: true)
                VStack(alignment: .leading) {
                    Text(title)
                        .bold()
                        .font(.system(size: 16, design: .serif))
                    Text(description)
                        .font(.system(size: 12, design: .serif))
                        .multilineTextAlignment(.leading)
                        .frame(alignment: .leading)
                }
            }
            .contentShape(Rectangle())
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 10)
    }
}
