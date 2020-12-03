//
//  UserService.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 30/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Firebase

typealias DatabaseCompletion = ((Error?,DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String, completion : @escaping(User) -> Void) {
        REF_USER.child(uid).observeSingleEvent(of: .value) { snapshoot in
            guard let dictionary = snapshoot.value as? [String : AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
//        print("DEBUG : CURRENT uid is \(uid)")
    }
    func fetchUser (completion: @escaping ([User]) -> Void) {
        var users = [User]()
        REF_USER.observe(.childAdded) { snapshoot in
            let uid = snapshoot.key
            guard let dictionary = snapshoot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1 ]) {(err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1 ], withCompletionBlock: completion)
        }
    }
    func unfollowUser (uid :String , completion : @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue {(err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    func checkIfUserIsFollowed(uid : String, completion : @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshoot in
            //print("DEBUG: USER IS FOLLOWED \(snapshoot.exists())")
            completion(snapshoot.exists())
        }
    }
    func fetchUserStats(uid: String, completion : @escaping(UserRelationStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshoot in
            let followers  = snapshoot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshoot in
                let following = snapshoot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    func updateProfileImage(image : UIImage , completion : @escaping(URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error ) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USER.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserData(user : User, completion : @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname" : user.fullname, "username": user.username, "bio": user.bio ?? ""]
        
        REF_USER.child(uid).updateChildValues(values, withCompletionBlock: completion)
        
    }
    
    func fetchUser(withUsername username : String, completion : @escaping(User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshoot in
            guard let uid = snapshoot.value as? String else { return }
            self.fetchUser(uid : uid, completion: completion)
        }
    }
}
