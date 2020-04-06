//
//  AuthButton.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 3.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        isEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
