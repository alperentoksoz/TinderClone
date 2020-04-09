//
//  Service.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 4.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import Firebase

struct Service {
    
    // MARK: - Fetching
      
      static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
          COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
              guard let dictionary = snapshot?.data() else { return }
              let user = User(dictionary: dictionary)
              completion(user)
          }
      }
      
      static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void) {
          var users = [User]()
          
          let query = COLLECTION_USERS.whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge).whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
          
          fetchSwipes { (swipedUserIDs) in
              query.getDocuments { (snapshot, error) in
                  if let error = error {
                      print("DEBUG: \(error.localizedDescription)")
                  } else  {
                      guard let snapshot = snapshot else { return }
                      snapshot.documents.forEach({ (document) in
                          let dictionary = document.data()
                          let user = User(dictionary: dictionary)
                        
                          guard user.uid != Auth.auth().currentUser?.uid else { return }
                          guard swipedUserIDs[user.uid] == nil else { return }
                          users.append(user)
                          

                      })
                      completion(users)
                  }
              }
          }
      }
    
    private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else {
            completion([String:Bool]())
            return
        }
        completion(data)
        }
    }
    
        // MARK: - Saving
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        
        let data = ["uid": user.uid,
                    "fullname": user.name,
                    "imageURLs": user.imageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String : Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void )?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            let data = [user.uid : isLike]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }

    
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let profileImageUrl = matchedUser.imageURLs.first else { return }
        guard let currentUserProfileImageUrl = currentUser.imageURLs.first else { return }
        
    }

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
