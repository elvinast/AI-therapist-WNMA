//
//  FirebaseImage.swift
//  AI-therapist
//
//  Created by Akniyet Turdybay on 24/12/24.
//

import SwiftUI
import Combine
import FirebaseStorage

struct FirebaseImage: View {
    
    let placeholder = UIImage(named: "default_prof_pic")!
    
    init(id: String) {
        self.imageLoader = Loader(id)
    }
    
    @ObservedObject private var imageLoader: Loader
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    var body: some View {
        Image(uiImage: image ?? placeholder)
            .resizable()
    }
}

struct FirebaseImage_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseImage(id: "AI-therapistBotPic.png")
    }
}
