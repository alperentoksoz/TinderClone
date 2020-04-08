//
//  ProfileController.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 7.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func profileController(_ controller: ProfileController, didLikeUser user: User)
    func profileController(_ controller: ProfileController, didDislikeUser user: User)
}

class ProfileController: UIViewController {
    // MARK: - Properties
    
    private let user: User
    
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var viewModel = ProfileViewModel(user: user)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismisall), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Actress"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "I was in transformers"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "dismiss_circle"))
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    
    private lazy var superlikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "super_like_circle"))
        button.addTarget(self, action: #selector(handleSuperlike), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like_circle"))
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadUserData()
    }
    
    // MARK: - Selectors
    
    @objc func handleDismisall() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDislike() {
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc func handleSuperlike() {
        
    }
    
    @objc func handleLike() {
        delegate?.profileController(self, didLikeUser: user)
    }
    
    // MARK: - Helpers
    
    func loadUserData() {
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        professionLabel.text = viewModel.profession
        bioLabel.text = viewModel.bio
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top:collectionView.bottomAnchor,right: view.rightAnchor,paddingTop: -20,paddingRight: 16)
        
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel,professionLabel,bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
        
        configureBottomControls()
     
    }
    
    func configureBottomControls() {
        let stack = UIStackView(arrangedSubviews: [dislikeButton,superlikeButton,likeButton])
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 32)
    }
    
    func createButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        
        return cell
        
    }
    
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
