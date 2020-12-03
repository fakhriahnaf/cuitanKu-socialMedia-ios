//
//  NotificationViewModel.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 11/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    private let notification : Notification
    private let type : NotificationType
    private let user : User
    
    var TimestampString : String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp , to: now ) ?? "2m"
    }
    
    var notificationMessage : String {
        switch type {
        case .follow : return "start following you"
        case .like : return "di like cuy postnya"
        case .reply : return "di replay postnya"
        case .metion : return "di mension coy"
        case .retweet: return "eh di rePost"
        }
    }
    
    var notificationText : NSAttributedString? {
        guard let timestamp = TimestampString else { return nil }
        let atributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        atributedText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)]))
        atributedText.append(NSAttributedString(string: "\(timestamp)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return atributedText
    }
    
    var profileImageUrl : URL? {
        return user.profilImageUrl
    }
    
    var shouldHideFollowButton : Bool {
        return type != .follow
    }
    
    var followButtonText : String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    init(notification : Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
        
    }
}

