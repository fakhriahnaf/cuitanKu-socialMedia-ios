//
//  ActionSheetViewModel.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 08/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user : User
    
    var option : [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption : ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
            
        }
        results.append(.report)
        
        return results
    }
    
    init (user: User) {
        self.user = user
        
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description : String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report :
            return "report Post"
        case .delete :
            return "Delete Post"
        }
    }
}
