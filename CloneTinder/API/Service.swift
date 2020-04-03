//
//  Service.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 1.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import Firebase

struct Service {
    

    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            } else {
                ref.downloadURL { (url, error) in
                    guard let imageUrl = url?.absoluteString else { return }
                    completion(imageUrl)
                }
            }
        }
    }
    
    
    
}
