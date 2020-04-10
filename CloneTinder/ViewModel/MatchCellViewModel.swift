//
//  MatchCellViewModel.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 10.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import Foundation

struct MatchCellViewModel {
    
    let nameText: String
    var profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid

    }
}
