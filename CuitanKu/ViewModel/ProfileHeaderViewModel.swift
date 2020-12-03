//
//  ProfileHeaderViewModel.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 07/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit


enum ProfileFilterOptions : Int,CaseIterable {
    case posts
    case replies
    case likes
    
    var description : String {
        switch self {
        case .posts: return "Posts"
        case .replies : return "Posts & Replies"
        case .likes : return "Likes"
        //default:
            
        }
    }
    
}

struct ProfileHeaderViewModel  {
    
    private let user : User
    
    let usernameText : String
    
    var followerString : NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString : NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    var actionButtonTitle : String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        if user.isFollowed {
            return "Following"
        }
        return "loading"
    }
    
    
    init (user : User){
        self.user = user
        
        self.usernameText = "@" + user.username
    }
    fileprivate func attributedText(withValue value : Int, text : String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [ .font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
    
}
