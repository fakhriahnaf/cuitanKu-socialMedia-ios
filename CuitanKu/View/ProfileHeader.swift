//
//  ProfileHeader.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 06/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

// ini page untuk melihat halaman profile


import UIKit
import SDWebImage

protocol ProfileHeaderDelegate : class {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
    func didSelect(filter : ProfileFilterOptions)
}

class ProfileHeader : UICollectionReusableView {
    
    //MARK - PROPERTIES
    var user : User? {
        didSet { configure() }
    }
    weak var delegate : ProfileHeaderDelegate?
    private let filterbar = ProfileFillterView()
    
    private lazy var containerView :UIView = {
        let view = UIView()
        view.backgroundColor = .cuitankuTosca
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor , left: view.leftAnchor, paddingTop: 42 , paddingLeft:16 )
        backButton.setDimensions(width: 30, height: 30)
        
        
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal),for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        //iv.setDimensions(width: 48, height: 48)
        iv.clipsToBounds = true
        //iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4 
        
        return iv
    }()
    
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOADING", for: .normal)
        button.layer.borderColor = UIColor.cuitankuTosca.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.cuitankuTosca, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //label.textColor = .lightGray
        //label.text = "FAKHRI AHNAF"
        return label
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
//        label.text = "@fakhri_ahnaf"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 3
        //label.text = "Woy ngape kepo dah"
    
        return label
    }()
    
    
    
    private let followingLabel : UILabel = {
        let label = UILabel()
        
        //label.text = "0 Following"
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    }()
    
    private let followersLabel : UILabel = {
        let label = UILabel()
        //label.text = "0 Followers"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    }()
    
    
    
    
    
    
    //MARK - LIFECYCLE
    override init (frame:CGRect) {
        super.init(frame: frame)
        
        filterbar.delegate = self
        
        //backgroundColor = .red
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor , height:108 )
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor,paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor , right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel,bioLabel])
        
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor( top : profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor , paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
         
        addSubview(followStack)
        followStack.anchor( top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterbar)
        filterbar.anchor(left : leftAnchor, bottom : bottomAnchor , right: rightAnchor , height: 50 )
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK - SELECTOR
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }

    //MARK - HELPPERS
    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profilImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followerString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
        
    }

}

extension ProfileHeader : ProfileFillterViewDelegate {
    func filterView(_ view: ProfileFillterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        
        print("DEBUG : CONTROLL WITH FILTER \(filter.description)")
        delegate?.didSelect(filter: filter)
//        guard let cell  = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {
//           return
//        }
//        let xPosition = cell.frame.origin.x
//        UIView.animate(withDuration: 0.3) {
//            self.underlineView.frame.origin.x = xPosition
//        }
    }
}
