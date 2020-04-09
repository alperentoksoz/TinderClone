//
//  HomeController.swift
//  TinderClone
//
//  Created by Alperen Toksöz on 01.04.2020.
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
    
        func logout() {
            do {
                try Auth.auth().signOut()
                presentLoginController()
            } catch _ {
                print("Failed to signOut")
            }
        }
    
        func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
            Service.saveSwipe(forUser: user, isLike: didLike) { (error) in
                self.topCardView = self.cardViews.last
                
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
    
    func perfomSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: (self.topCardView?.frame.width)!, height: (self.topCardView?.frame.height)!)
        }) { (_) in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
    
}

   // MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview() 
        self.cardViews.removeAll(where: { view == $0 })

        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)

        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller,animated: true,completion: nil)
    }
}
    

    
   // MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        perfomSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        
        perfomSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        guard let user = self.user else { return }
        
        Service.fetchUsers(forCurrentUser: user) { (users) in
            self.cardViewModels = users.map( { CardViewModel(user:  $0) })
        }
    }
    
}

    // MARK: - ProfileControllerDelegate

extension HomeController: ProfileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
    

    // MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
    }
}
