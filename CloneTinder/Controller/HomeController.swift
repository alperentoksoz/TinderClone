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
    
    private var user: User?
    
    private var cardViewModels = [CardViewModel]() {
        didSet {
            configureCards()
        }
    }
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUserAndCards()
        checkIfUserIsLoggedIn()
        configureUI()
    }
    
    // MARK: - API
        
        func fetchUsers(forCurrentUser user: User) {
            Service.fetchUsers(forCurrentUser: user) { (users) in
               
            self.cardViewModels = users.map({ CardViewModel(user: $0)})

            }
        }
        
        func fetchCurrentUserAndCards() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Service.fetchUser(withUid: uid) { (user) in
                 print("DEBUG: \(user.name)")
                self.user = user
                self.fetchUsers(forCurrentUser: user)
            }
        }
        
        func checkIfUserIsLoggedIn() {
            if Auth.auth().currentUser == nil {
                presentLoginController()
            }
        }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureCards() {
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(viewModel: cardViewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    
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
    
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav,animated: true,completion: nil)
        }
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
    

    // MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
    }
}
