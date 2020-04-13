//
//  Match.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 1.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import Foundation

struct Match {
    let name: String
    let profileImageUrl: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
