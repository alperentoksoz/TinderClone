//
//  CustomTextField.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 1.06.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeHolder: String, isSecureStype: Bool?) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        autocapitalizationType = .none
        keyboardAppearance = .dark
        isSecureTextEntry = isSecureStype!
        borderStyle = .none
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        

        
        attributedPlaceholder = NSMutableAttributedString(string: placeHolder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
