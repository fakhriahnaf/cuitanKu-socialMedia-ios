//
//  UploadPostController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 02/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import SDWebImage
import ActiveLabel



class UploadPostController: UIViewController {
    
    //MARK - PROPERTIES
     
    private let user : User
    private let config : UploadPostConfiguration
    private lazy var viewModel  = UploadPostViewModel(config : config)
    
    
    private lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .cuitankuTosca
        button.setTitle("Post", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        
        return button
        
    }()
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .cuitankuTosca
        return iv
        
    }()
    
    private lazy var replyLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .cuitankuTosca
        label.text = "replying to @warbiezz"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK - LIFECYCLE
    
    init (user: User , config: UploadPostConfiguration){
        self.user = user
        self.config = config
        super.init(nibName: nil,bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMentionHandler()
    }
    //MARK - SELECTOR
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadPost() {
        guard let caption = captionTextView.text else { return }
        PostService.shared.uploadPost(caption: caption , type: config) {( error, ref) in
            if let error = error {
                print("DEBUG : failed to upload post with error \(error.localizedDescription)")
                return
            }
            
            if case .reply(let post) = self.config {
                NotificationService.shared.uploadNotification(toUser: post.user, type: .reply, postID: post.postID)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK - API
    fileprivate func uploadMentionNotification(forCaption caption: String, postID: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        words.forEach {  word in
            guard word.hasPrefix("@") else { return }
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            
            UserService.shared.fetchUser(withUsername: username) { mentionUser in
                NotificationService.shared.uploadNotification(toUser: mentionUser, type: .metion , postID: postID)
            }
            
        }
    }
    
    //MARK - HELPERS
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        //stack.alignment = .leading
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor , paddingTop: 16, paddingLeft: 16 , paddingRight:  16)
        
        profileImageView.sd_setImage(with: user.profilImageUrl, completed: nil)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
       
    }
    //BUTTON ATAS (CANCLE DAN POST)
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
               
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
    }
    
    func configureMentionHandler() {
        replyLabel.handleMentionTap { mention in
            print("Debug : mention user is \(mention)")
        }
    }
    
}
