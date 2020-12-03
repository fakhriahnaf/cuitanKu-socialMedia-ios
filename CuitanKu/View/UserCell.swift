//
//  UserCell.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 29/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class UserCell : UITableViewCell {
    
    //MARK : - Properties
    var user: User? {
        didSet { configure() }
    }
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 32, height: 32)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 32/2
        iv.backgroundColor = .cuitankuTosca
        return iv
        
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        //label.numberOfLines = 0
        label.text = "Username"
        return label
    }()
    private let fullnameLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 14)
           //label.numberOfLines = 0
           label.text = "Fullname"
           return label
       }()
    //Mark : - Lifecycle
    
    override init (style : UITableViewCell.CellStyle, reuseIdentifier : String?) {
        super.init(style : style, reuseIdentifier : reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - HELPERS
    func configure() {
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: user.profilImageUrl)
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
