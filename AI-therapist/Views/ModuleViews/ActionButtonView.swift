//
//  ActionButtonView.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 16/12/24.
//

import SwiftUI

struct ActionButtonView: View {
    var text: String?
    var symbolName: String?
    var action: (() -> Void)?
    
    var body: some View {
        
        if let text, let symbolName, let action {
            Button(action: action) {
                // Action icon
                Image(systemName: symbolName).foregroundColor(.white).font(.system(size: 25))
                
                // Action text
                Text(text).font(.system(size: 25, design: .serif))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }.frame(width: 350)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.white, lineWidth: 2))
                .foregroundColor(.white)
        }
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView()
    }
}
