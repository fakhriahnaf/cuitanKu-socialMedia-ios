//
//  EditProfileHeader.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 24/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader : UIView {
    
    //MARK : - PROPERTIES
    private let user: User
    weak var delegate : EditProfileHeaderDelegate?
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3.0
        return iv
        
    }()
    
    private let changePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("change profile picture", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfileButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    //MARK : - LIFECYCLE
    init(user: User) {
        self.user = user
        super.init(frame : .zero)
        
        backgroundColor = .cuitankuTosca
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        
        profileImageView.sd_setImage(with: user.profilImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK :- selector
    @objc func handleChangeProfileButton() {
        delegate?.didTapChangeProfilePhoto()
        
    }
    
    //MARK :- HELPERS
}

