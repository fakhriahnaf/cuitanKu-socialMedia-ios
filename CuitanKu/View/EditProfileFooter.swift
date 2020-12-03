//
//  EditProfileFooter.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 30/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit


protocol EditProfileFooterDelegate : class {
    func handleLogout()
}

class EditProfileFooter :UIView {
    //MARK :- PROPERTIES
    
    weak var delegate : EditProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK :- LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right:  rightAnchor, paddingLeft: 16, paddingRight:16 )
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
        //logoutButton.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //mark : - selector
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
