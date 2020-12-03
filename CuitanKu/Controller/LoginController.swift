//
//  LoginController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 28/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class LoginController : UIViewController {
    
    // MARK - PROPERTIES
    private let logoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "bacotanLogo")
        return iv
    }()
    
    //email kolom
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
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.cuitankuTosca, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50) .isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
        
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(firstPart: "dont have account?", secondPart: "Sign UP!")
        button.addTarget(self, action: #selector(handleShowSignUP), for: .touchUpInside)
         return button
        
    }()
    @objc func handleShowSignUP() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
        
    
    // MARK - LIFESYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK - SELECTORS
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        AuthService.shared.loginUser(withEmail: email, password: password){(result,error)in
            if let error = error {
                print("DEBUG : Error logging in \(error.localizedDescription)")
                return
            }
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
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 200, height: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32 , paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
                dontHaveAccountButton.anchor(left : view.leftAnchor,
                                             bottom : view.safeAreaLayoutGuide.bottomAnchor,
                                             right: view.rightAnchor, paddingLeft: 40,
                                             paddingBottom: 16, paddingRight: 40)
    
    }
}

