//
//  NotificationsController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 27/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

private let reusableIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    
    // MARK = - Propertis
    
    private var notifications = [Notification]() {
        didSet {tableView.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //Mark = - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    //MARK : - SELECTOR
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    //MARK : - API
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkIfUserIsFollowed(notification: notifications)
            
            
        }
    }
    
    func checkIfUserIsFollowed(notification: [Notification]) {
        guard !notification.isEmpty else { return }
        
        notification.forEach { notification in
            guard case .follow = notification.type else { return }
            let user = notification.user
            
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.user.uid == notification.user.uid}) {
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK : - HELPERS
    //buat navigasi atas Bar
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}


//NOTIFIKASI VIEW DATA SOURCE
extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! NotificationCell
        //cell.backgroundColor = .systemPurple
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

//MARK :- UITABLEVIEW DELEGATE
extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let postID = notification.postID else { return }
        
        PostService.shared.fetchPost(withPostID: postID) { post in
            let controller = PostController(post: post)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        //print("debug : post is \(notification.postID)")
    }
}

//MARK : - NOTIFICATION CELL DELEGATE
extension NotificationsController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        //print("debug : did tab handle follow you")
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            //print("DEBUG : HANDLE UNFOLLOW")
            UserService.shared.unfollowUser(uid: user.uid) { (err,ref) in
                cell.notification?.user.isFollowed = false
            }
        } else {
            //print("DEBUG : HANDLE FOLLWO")
            UserService.shared.followUser(uid: user.uid) { (err,ref) in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
