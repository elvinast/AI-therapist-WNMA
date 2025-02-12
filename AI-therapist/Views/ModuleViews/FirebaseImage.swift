//
//  FirebaseImage.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/2/23.
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
        FirebaseImage(id: "RadiantBotPic.png")
    }
}
