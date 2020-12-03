//
//  MainTabController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 27/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import Firebase

enum ActionButtonConfigure {
    case post
    case message
}
class MainTabController: UITabBarController {
    
    // MARK = - Propertis
    private var buttonConfig : ActionButtonConfigure = .post
    
    var user : User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
        }
    }
    
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .cuitankuTosca
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    
    //Mark = - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        logUserOut()
        view.backgroundColor = .cuitankuTosca
        authenticateUserAndConfigureUI()
//        configureViewControllers()
//        configureUI()

    }
    // MARK - API
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            
            
        }
    }
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true , completion: nil)
            }
//            print("DEBUG : USER is not logged in..")
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
           // print("DEBUG : USER is logged in.. ")
        }
    }
    
    
    
    //MARK - SELECTORS
    @objc func actionButtonTapped(){
        
        let controller : UIViewController
        
        switch buttonConfig {
        case .message:
            controller = SearchController(config: .message)
        case .post:
            guard let user = user else { return }
            controller = UploadPostController(user : user, config: .post)
        }
        
        //guard let user = user else { return }
        //let controller = UploadPostController(user: user , config: .post) 
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    //Mark = - Helpers
    //floating action button (melayang)
    func configureUI(){
        self.delegate = self
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, right : view.rightAnchor, paddingBottom: 64, paddingRight:16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
        
    
    }
    
    //Menu Bar
    func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController :feed)
        
        let explore = SearchController(config: .userSearch)
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController :explore)
        
        let notification = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController : notification)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController : conversations)
        
        
        
        viewControllers = [ nav1, nav2, nav3, nav4]
        
    }
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
        
    }
}

extension MainTabController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let image = index == 3 ? #imageLiteral(resourceName: "ic_mail_outline_white_2x-1") : #imageLiteral(resourceName: "new_tweet")
        self.actionButton.setImage(image, for: .normal)
        buttonConfig = index == 3 ? .message : .post
    }
}

