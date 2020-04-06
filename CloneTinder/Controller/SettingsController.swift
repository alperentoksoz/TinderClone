//
//  SettingsController.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 05.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit
import JGProgressHUD

private let reuseIdentifier = "SettingsCell"

protocol SettingsControllerDelegate: class {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func settingsControllerWantsToLogout(_ controller: SettingsController)
}

class SettingsController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    
    private lazy var headerView = SettingsHeader(user: user)
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    weak var delegate: SettingsControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Your Data"
        hud.show(in: view)
        
        view.endEditing(true)
        Service.saveUserData(user: user) { (error) in
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
    }
    
    // MARK: - API
    
    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Images"
        hud.show(in: view)
        
        Service.uploadImage(image: image) { (imageUrl) in
            self.user.imageURLs.append(imageUrl)
            hud.dismiss()
        }
    }
    
    // MARK: - Helpers
    
    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))

        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)


    }
}

    // MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker,animated: true,completion: nil)
    }
    
    
}

    // MARK: - UIImagePickerControllerDelegate

extension SettingsController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
}
