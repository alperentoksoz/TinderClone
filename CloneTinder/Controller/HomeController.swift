//
//  HomeController.swift
//  TinderClone
//
//  Created by Alperen Toksöz on 31.05.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - API
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [topStack,deckView,bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top:view.safeAreaLayoutGuide.topAnchor,left:view.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)

    }
    
}
    
   // MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
         print("DEBUG: Handle like.")
    }
    
    func handleDislike() {
        print("DEBUG: Handle dislike.")
    }
    
    func handleRefresh() {
        print("DEBUG: Handle refresh.")
    }
    
}

