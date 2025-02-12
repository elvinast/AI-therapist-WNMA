//
//  EducationArticleView.swift
//  AI-therapist
//
//  Created by Elvina Shamoi on 09/01/25.
//

import SwiftUI

struct EducationArticleView: View {
    var bg_image = "Forum_BG2"
    var completed: Bool = true
    var title: String
    
    var body: some View {
        NavigationLink(destination: ThinkingErrorsInfoView()) {
            // BG
            VStack {
                Text("Thinking Errors")
                    .foregroundColor(.black)
                    .font(.system(size: 18, design: .serif))
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 300, maxWidth: 300, minHeight: 240, maxHeight: 240)
                    .foregroundColor(.blue)
                    .overlay {
                        ZStack {
                            Image("Home_Welcome_BG")
                                .resizable()
                                .cornerRadius(25)
                        }
                    }
            }
            
        }
    }
}

struct EducationArticleView_Previews: PreviewProvider {
    static var previews: some View {
        EducationArticleView(title: "Base Education Article")
    }
}
