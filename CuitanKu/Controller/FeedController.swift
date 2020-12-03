//
//  FeedController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 27/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import SDWebImage

private let reusableIdentifier = "PostCell"



class FeedController: UICollectionViewController  {
    
    // MARK = - Propertis
    var user : User? {
        didSet{ configureLeftBarButton() }
    }
    
    private var posts = [Post](){
        didSet { collectionView.reloadData() }
    }
    
    //Mark = - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK : - SELECTOR
    @objc func handleRefresh() {
        fetchPosts()
    }
    
    @objc func handleProfileImageTap() {
        guard let user = user else { return }
        let controller = ProfileController(user : user)
        navigationController?.pushViewController(controller, animated: true)
    }
    //MARK - API
    func fetchPosts() {
        collectionView.refreshControl?.beginRefreshing()
        PostService.shared.fetchPosts { posts in
           // print("DEBUG : number of post is \(posts.count)")
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp})
            self.checkIfUserLikedPost(self.posts)
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedPost(_ posts : [Post]) {
        self.posts.forEach { post in
            PostService.shared.checkIfUserLikedPost(post) { didLike in
                guard didLike == true else { return }
                
                if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                    self.posts[index].didLike = true
                }
            }
        }
    }
    
///MARK - HELPERS
    //buat navigasi atas Bar
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named:"cuitanku_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        
    }
    
//HAMBURGER BAR
    func configureLeftBarButton() {
        guard let user = user  else { return }
        
        let profileImageView =  UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageView.addGestureRecognizer(tap)
        
        profileImageView.sd_setImage(with: user.profilImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }

}

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView : UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! PostCell
        
        cell.delegate = self
        cell.post = posts[indexPath.row]
        
        return cell 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PostController(post: posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK : - UICOLLECTION VIEW DELEGATE FLOW LAYOUT
extension FeedController : UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath : IndexPath) -> CGSize {
        let viewModel = PostViewModel(post: posts[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 75 ) //ukuran kolom post feed
    }
}

// MARK - POST CELL DELEGATE
extension FeedController : PostCellDellegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLikeTapped(_ cell: PostCell) {
        guard let post = cell.post else { return }
        
        PostService.shared.likePost(post: post) {(ref,err) in
            cell.post?.didLike.toggle()
            let likes = post.didLike ? post.likes - 1 : post.likes + 1
            cell.post?.likes = likes
            
            //only update notification if post being like
            guard !post.didLike else { return }
            NotificationService.shared.uploadNotification( toUser: post.user ,type: .like, postID: post.postID)
        }
    }
    
    func handleReplyTapped(_ cell: PostCell) {
        guard let post = cell.post else { return }
        let controller = UploadPostController(user: post.user, config: .reply(post))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav,animated: true , completion:  nil)
    }
    
    func handleProfileImageTapped(_ cell: PostCell) {
        guard let user = cell.post?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
