//
//  Notification.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 10/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Foundation

enum NotificationType : Int {
    case follow
    case like
    case reply
    case retweet
    case metion
}

struct Notification {
    //let uid: String
    var postID: String?
    var timestamp : Date!
    var user : User
    var post : Post?
    var type : NotificationType!
    
    init(user : User , dictionary: [String : AnyObject]) {
        self.user = user
        //self.post = post
        
        //self.postID = dictionary["postID"] as? String ?? ""
        
        if let postID = dictionary["postID"] as? String {
            self.postID = postID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
