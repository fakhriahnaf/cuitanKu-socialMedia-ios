//
//  ProfileController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 05/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "PostCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    //MARK - PROPERTIES
    private var user : User
    
    private var selectedFilter : ProfileFilterOptions = .posts {
        didSet { collectionView.reloadData()}
    }
    
    private var posts = [Post]()
    private var likedPosts = [Post]()
    private var replies = [Post]()
    
    private var currentDataSource : [Post] {
        switch selectedFilter {
        case .posts : return posts
        case .replies : return replies
        case .likes : return likedPosts
        }
    }
    
    //MARK - LIFECYCLE
    init (user : User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchPosts()
        fetchReplies()
        fetchLikePost()
        checkIfUserIsFollowed()
        fetchUserStats()
        
        //print("DEBUG : username is \(user.username)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
         
    }
    
    //MARK : - API
    
    
    func fetchPosts() {
        PostService.shared.fetchPosts(forUser: user) { posts in
            //print("Post are \(posts)")
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    func fetchLikePost() {
        PostService.shared.fetchLike(forUser: user) { posts in
            self.likedPosts = posts
        }
    }
    
    func fetchReplies() {
        PostService.shared.fetchLike(forUser: user) { posts in
            self.replies = posts
            
//            self.replies.forEach  { reply in
//                print("DEBUG : REPLYING TO \(reply.replyingTo)")
//            }
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            
        }
    }
    
    //MARK - HELPERS
    func configureCollectionView () {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind : UICollectionView.elementKindSectionHeader, withReuseIdentifier : headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
        
    }
    
}

// MARK - UICOLLECTION VIEW DATA SOURCE

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.post = currentDataSource[indexPath.row]
        return cell
    }
}

// MARK - UI collection  VIEW DELEGATE
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PostController(post: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK - UI COLLECTION VIEW FLOW LAYOUT DELEGATE

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section : Int) -> CGSize {
        
        
        var height : CGFloat = 300
        
        if user.bio != nil {
            height += 50
        }
        return CGSize(width: view.frame.width, height: height) //ukuran frame
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath : IndexPath) -> CGSize {
        let viewModel = PostViewModel(post: currentDataSource[indexPath.row])
        var height = viewModel.size(forWidth: view.frame.width).height + 72
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
}


//MARK : - ProfileHandleDelegate

extension ProfileController : ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
        //print("Debug : handle dismiss profile from controller...")
    }
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrentUser {
            //print("DEBUG: Show edit profile controller..")
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (ref, err) in
                self.user.isFollowed = false
                //header.editProfileFollowButton.setTitle("Follow", for: .normal)
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (err,ref) in
                self.user.isFollowed = true
                //header.editProfileFollowButton.setTitle("Following", for: .normal)
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
            }
        }
    }
}

extension ProfileController: EditProfileControllerDelegate {
    func handleLogout() {
            do {
                try Auth.auth().signOut()
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            } catch let error {
                print("DEBUG : Failed to sign out with error \(error.localizedDescription)")
            }
        }
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
        self.collectionView.reloadData()
    }
}
