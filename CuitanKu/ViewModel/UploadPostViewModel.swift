//
//  UploadPostViewModel.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 04/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

enum UploadPostConfiguration {
    case post
    case reply(Post)
}

struct UploadPostViewModel {
    let actionButtonTitle : String
    let placeholderText : String
    var shouldShowReplyLabel : Bool
    var replyText : String?
    
    init(config: UploadPostConfiguration) {
        switch  config {
        case .post:
            actionButtonTitle = "Post"
            placeholderText = "Apa hayo?"
            shouldShowReplyLabel = false
        case .reply(let post):
            actionButtonTitle = "Reply"
            placeholderText = "Post your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(post.user.username)"
            
        }
    }
}
