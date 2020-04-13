//
//  RegistrationController.swift
//  TinderClone
//
//  Created by Alperen Toksöz on 3.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController{
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private let emailTextField = CustomTextField(placeHolder: "Email",isSecureStype: false)
    private let fullnameTextField = CustomTextField(placeHolder: "Fullname",isSecureStype: false)
    private let passwordTextField : CustomTextField = {
          let tf = CustomTextField(placeHolder: "Password",isSecureStype: true)
          return tf
      }()
    private var profileImage: UIImage?
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var gotoRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have account?  ", attributes: [.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(gotoLoginScreen), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        configureTextFieldObservers()
        configureUI()

    }
    
    // MARK: - Selectors
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullname = sender.text
        }
        
        checkFormStatus()
        
    }
    
    @objc func handleSelectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker,animated: true,completion: nil)
        
    }
    
    @objc func handleRegister() {
        guard let email = emailTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImage: profileImage)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Singing In"
        hud.show(in: view)
        
        AuthService.registerUser(withCredentials: credentials) { (error) in
            if let error = error {
                print("DEBUG: Error signing user up \(error.localizedDescription)")
                hud.dismiss()
            }
            hud.dismiss()
            self.delegate?.authenticationComplete()
        }
    }
    
     @objc func gotoLoginScreen() {
        navigationController?.popViewController(animated: true)
     }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,fullnameTextField,passwordTextField,authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(gotoRegistrationButton)
        gotoRegistrationButton.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 16,paddingRight: 16)
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

    // MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
}
