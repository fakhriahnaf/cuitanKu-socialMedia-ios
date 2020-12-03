//
//  User.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 30/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var fullname : String
    let email : String
    let password : String
    let uid : String
    var profilImageUrl : URL?
    var username : String
    var isFollowed = false
    var stats: UserRelationStats?
    var bio: String?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid  }
    
    init (uid : String , dictionary :[String : AnyObject]){
        self.uid = uid
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        //self.bio = dictionary["bio"] as? String ?? ""
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String  {
            guard let url = URL(string: profileImageUrlString) else {return}
            self.profilImageUrl = url
        }
    }
}
struct UserRelationStats {
    var followers : Int
    var following : Int
}
