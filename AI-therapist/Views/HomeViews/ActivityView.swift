//
//  ActivityView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 22/12/24.
//

import SwiftUI

struct ActivityView: View {
    var bg_image = "Forum_BG2"
    var completed: Bool = true
    var title: String
    
    
    var body: some View {
        NavigationLink(destination: ActivityPageView(title: title)) {
            RoundedRectangle(cornerRadius: 25)
                .frame(minWidth: 250, maxWidth: 300, minHeight: 200, maxHeight: 200)
                .foregroundColor(.blue)
                .overlay {
                    ZStack {
                        Image(bg_image)
                            .resizable()
                            .cornerRadius(25)
                        
                        VStack {
//                            if completed {
//                                Image(systemName: "checkmark.circle.fill")
//                                    .resizable()
//                                    .frame(width: 28, height: 28)
//                                    .foregroundColor(.green)
//                                    .offset(y: -40)
//                                    .offset(x: 100)
//
//                            }
                            
                            Text(title)
                                .foregroundColor(.white)
                                .padding(.bottom, 40)
                                .font(.system(size: 18, design: .serif))
                            
                            Text("")
                                .padding(.top, 60)
                        }
                    }
                }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}


struct ActivityPageView: View {
    var title: String
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 30, design: .serif))
                    .bold()
                    .padding(20)
                    .offset(y: -100)
                
                Text("This is going to be the description of the activity. The base will be a personality quiz. I need to figure out how to modularize these things so I can make a lot of them.")
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                    .offset(y: -100)
                
                Button(action: {
                    print("User wanted to check in")
                }) {
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
                .foregroundColor(.blue)
                .padding(20)
                .offset(x: 15)
            }
        }
    }
}
