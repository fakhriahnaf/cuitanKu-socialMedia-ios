//
//  Post.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 03/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Foundation

struct Post {
    let caption : String
    let postID : String
    let uid     : String
    var likes   : Int
    var timestamp : Date!
    let reetweetCount : Int
    var user : User
    var didLike = false
    var replyingTo: String?
    
    var isReply : Bool { return replyingTo != nil }
    
    init(user : User ,postID: String, dictionary : [String: Any]) {
        self.postID = postID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.reetweetCount = dictionary["reetweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["ReplyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}

