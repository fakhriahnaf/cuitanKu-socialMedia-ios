//
//  PostController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 01/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PostCell"
private let headerIdentifier = "PostHeader"

class PostController : UICollectionViewController {
    
    
    //MARK : - properties
    private let post : Post
    private var actionSheetLauncher : ActionSheetLauncher
    private var replies = [Post]() {
        didSet {collectionView.reloadData() }
    }
    
    //MARK : - Lifecycle
    
    init(post:Post) {
        self.post = post
        self.actionSheetLauncher = ActionSheetLauncher(user: post.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies() 
        
        print("DEBUG : Post caption is \(post.caption)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    //MARK : - API
    func fetchReplies() {
        PostService.shared.fetchReplies(forPost: post) { replies in
            self.replies = replies
        }
    }
    
    //MARK : - HELPERS
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier : headerIdentifier)
        
    }
    fileprivate func showActionSheet(forUser user : User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}

extension PostController {
    override func collectionView(_ collectionView : UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.post = replies[indexPath.row]
        return cell
    }
}

extension PostController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PostHeader
//        header.user = user
//        header.delegate = self
        header.post = post
        header.delegate = self
        return header
    }
}

extension PostController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section : Int) -> CGSize {
        
        let viewModel = PostViewModel(post: post)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 350)  //ukuran frame
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath : IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension PostController: PostHeaderDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
    func showActionSheet() {
        //actionSheetLauncher.show()
        
        if post.user.isCurrentUser{
            showActionSheet(forUser: post.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: post.user.uid) { isFollowed in
                var user = self.post.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
                 
            }
        }
    }
}

//MARK : - ACTIONSHEETLAUNCHER
extension PostController : ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                print("DEBUG : did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err,ref) in
                print("Debug : Unfollow \(user.username)")
            }
        case .report :
            print("Debug: report post")
        case .delete :
            print("DEBUG : DELETE POST")
        }
    }
}
