//
//  MessagesController.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 13.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class MessagesController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    private let headerView = MatchHeader()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
        fetchMatches()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchMatches() {
        Service.fetchMatches { (matches) in
            self.headerView.matches = matches
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        headerView.delegate = self
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        tableView.tableHeaderView = headerView
    }
    
    func configureNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
    }
}

    

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}

extension MessagesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.text = "New Matches"
        label.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
}

extension MessagesController: MatchHeaderDelegate {
    func matchHeader(_ header: MatchHeader, wantsToStartChatWith uid: String) {
        Service.fetchUser(withUid: uid) { (user) in
            print("DEBUG: Start chat with \(user.name)")
        }
    }
}
