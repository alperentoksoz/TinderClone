//
//  SettingsHeader.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 4.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit
import SDWebImage

protocol SettingsHeaderDelegate: class {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int)
}

class SettingsHeader: UIView {
    
    // MARK: - Properties
    
    private let user: User
    
    var buttons = [UIButton]()
    lazy var button1 = createButtons(0)
    lazy var button2 = createButtons(1)
    lazy var button3 = createButtons(2)
    
    weak var delegate: SettingsHeaderDelegate?
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .lightGray
        
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        button1.contentMode = .scaleAspectFill
        addSubview(button1)
        button1.anchor(top:topAnchor,left: leftAnchor,bottom: bottomAnchor,paddingTop: 16,paddingLeft: 16,paddingBottom: 16)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2,button3])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16,paddingBottom: 16, paddingRight: 16)    //
        
        loadUserPhotos()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleSelectPhoto(sender: UIButton) {
        delegate?.settingsHeader(self, didSelect: sender.tag)
    }
    
    // MARK: - Helpers
    
    func loadUserPhotos() {
        
        let imageURLs = user.imageURLs.map( {URL(string: $0) })
        
        for (index,url) in imageURLs.enumerated() {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    func createButtons(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        return button
    }
}
