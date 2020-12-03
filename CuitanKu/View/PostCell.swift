//
//  PostCell.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 03/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import ActiveLabel

protocol PostCellDellegate : class {
    func handleProfileImageTapped(_ cell: PostCell)
    func handleReplyTapped(_ cell: PostCell)
    func handleLikeTapped(_ cell: PostCell)
    func handleFetchUser(withUsername username : String)
}

class PostCell : UICollectionViewCell{
    
    //MARK - PROPERTIES
    var post : Post? {
        didSet { configure() }
    }
    
    weak var delegate: PostCellDellegate?
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 48, height: 48)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .cuitankuTosca
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
        
    }()
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .cuitankuTosca
        //label.text = "-> replying to @warbiez"
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .cuitankuTosca
        label.hashtagColor = .cuitankuTosca
        //label.text = "ini tulisan cuk"
        return label
    }()
    
    private lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    private lazy var retweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    private lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    private lazy var shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let infoLabel = UILabel()
    
    
    //MARK -LIFECYCLE
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        backgroundColor = .white
        
    
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionStack])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        
        addSubview(stack)
        stack.anchor(top: topAnchor ,left : leftAnchor , right: rightAnchor,paddingTop: 4, paddingLeft: 12, paddingRight:  12)
        
        //replyLabel.isHidden = false
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        //infoLabel.text =  "Fakhri Ahnaf @fakhri_ahnaf"
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 50 //sebelumnya ini 72
        
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom : bottomAnchor , paddingBottom: 8)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor , bottom: bottomAnchor, right: rightAnchor , height: 1)
        
        configureMentionHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: has not been implemented )")
    }
    
    //MARK - SELECTOR
    
    @objc func handleProfileImageTapped () {
      //  print("DEBUG : profile image tapped in cell ...")
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped () {
        delegate?.handleReplyTapped(self)
    }
    @objc func handleLikeTapped () {
        delegate?.handleLikeTapped(self) 
    }
    @objc func handleShareTapped () {
        
    }
    @objc func handleRetweetTapped () {
        
    }
    
    //MARK - HELPERS
    
    func configure() {
        guard let post = post else {return}
        let viewModel = PostViewModel(post: post)
        
        captionLabel.text = post.caption
       // print("DEBUG: User is .. \(post.user.username)")
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    func configureMentionHandler() {
        captionLabel.handleMentionTap { username in
            //print("DEBUG : FOR MANTION \(mention)")
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }
}

//extension FeedController : PostCellDellegate {
//    func handleProfileImageTapped() {
//        print("DEBUG : Handle profile image tapped in controller..")
//    }
//}
