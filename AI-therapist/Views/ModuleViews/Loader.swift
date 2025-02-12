//
//  Loader.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/2/23.
//

import Foundation
import SwiftUI
import Combine
import FirebaseStorage

final class Loader : ObservableObject {
    let didChange = PassthroughSubject<Data?, Never>()
    @Published var data: Data? = nil {
        didSet { didChange.send(data) }
    }

    init(_ id: String){
        // the path to the image
        let url = "profile_pictures/\(id)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 2048) { data, error in
            if let error = error {
                print("\(error)")
            } else {
                print("Image successfully found")
                self.data = data
            }

//            DispatchQueue.main.async {
//
//            }
        }
    }
}
