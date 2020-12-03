//
//  RegistrationController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 28/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK - PROPERTIES
    
    private let imagePicker = UIImagePickerController()
    private var profileImage : UIImage?
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddPhotoProfil), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage:image, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage:image, textField: passwordTextField)
        return view
    }()
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage:image, textField: fullnameTextField)
        
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage:image, textField: usernameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let fullnameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full name")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "username")
        return tf
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(firstPart: "I have account?", secondPart: "Sign UP!")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
        
    }()
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.cuitankuTosca, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50) .isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
        
    }()
    
    
    // MARK - LIFESYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK - SELECTORS
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    @objc func handleAddPhotoProfil() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegistration(){
        guard let profileImage = profileImage else {
            print("DEBUG : Please select a profile image..")
            return
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        
        let credentials = AuthCredentials(email: email , password:password, fullname:fullname , username: username, profileImage:profileImage)

      
        
        AuthService.shared.registerUser(credentials: credentials){ (error, ref) in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow})
                 else { return }
             guard let tab = window.rootViewController as? MainTabController else { return }
             
             tab.authenticateUserAndConfigureUI()
            // print("DEBUG : Succesfull Login .. ")
             self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    // MARK - HELPERS
    func configureUI() {
        view.backgroundColor = .cuitankuTosca
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView, registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32 , paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left : view.leftAnchor,
                                     bottom : view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 40,
                                     paddingBottom: 16, paddingRight: 40)
    }
}

// MARK - UI IMAGE PICKER

extension RegistrationController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController( _ picker : UIImagePickerController,  didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]) {
        guard let profilImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profilImage
        
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profilImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
}
