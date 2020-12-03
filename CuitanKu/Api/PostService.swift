//
//  PostService.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 03/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Firebase

struct PostService {
    static let shared = PostService()
    
    func uploadPost(caption: String, type: UploadPostConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = [  "uid": uid,
                        "timestamp" : Int(NSDate().timeIntervalSince1970),
                        "likes" : 0,
                        "retweets": 0 , 
                        "caption" : caption] as [String : Any]
        
        switch type {
        case .post:
             REF_TWEETS.childByAutoId().updateChildValues(values) { (err, ref) in
                guard let postID = ref.key else { return }
                REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
            }
//             update user-post structure after upload complete
        case .reply(let post):
            values["replyingTo"] = post.user.username
            
            REF_TWEET_REPLIES.child(post.postID).childByAutoId().updateChildValues(values) { (err,ref) in
                guard let replyKey = ref.key else { return }
                REF_USER_REPLIES.child(uid).updateChildValues([post.postID: replyKey], withCompletionBlock: completion)
            }
        }
    }
    
    func fetchPosts(completion : @escaping([Post]) -> Void) {
        var posts = [Post]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { snapshoot in
            let followingUid = snapshoot.key
            
            REF_USER_POSTS.child(followingUid).observe(.childAdded) { snapshoot in
                let postID = snapshoot.key
                
                self.fetchPost(withPostID: postID) { post in
                    posts.append(post)
                    completion(posts)
                }
            }
        }
        REF_USER_POSTS.child(currentUid).observe(.childAdded) { snapshoot in
            let postID = snapshoot.key
            
            self.fetchPost(withPostID: postID) { post in
                posts.append(post)
                completion(posts)
            }
        }
        
//        REF_TWEETS.observe(.childAdded) { snaphoot in
//            guard let dictionary = snaphoot.value as? [String : Any] else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            let postID = snaphoot.key
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                let post = Post(user: user, postID: postID, dictionary: dictionary)
//                posts.append(post)
//                completion(posts)
//            }
//        }
    }
    
    func fetchPosts(forUser user : User, completion : @escaping([Post]) -> Void) {
        var posts = [Post]()
        REF_USER_POSTS.child(user.uid).observe(.childAdded) { snapshoot in
            let postID = snapshoot.key
            
            self.fetchPost(withPostID: postID) { post in
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func fetchPost(withPostID postID: String, completion : @escaping(Post) -> Void) {
        REF_TWEETS.child(postID).observeSingleEvent(of: .value) { snapshoot in
            guard let dictionary = snapshoot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    func fetchReplies(forUser user : User, completion: @escaping([Post]) -> Void) {
        var replies = [Post]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshoot in
            let postKey = snapshoot.key
            guard let replyKey = snapshoot.value as? String else { return }
            
            REF_TWEET_REPLIES.child(postKey).child(replyKey).observeSingleEvent(of: .value) { snapshoot in
                guard let dictionary = snapshoot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                let replyID = snapshoot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Post(user: user, postID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    
    func fetchReplies(forPost post : Post, completion : @escaping([Post]) -> Void) {
        var posts = [Post]()
        
        REF_TWEET_REPLIES.child(post.postID).observe(.childAdded) { snapshoot in
            guard let dictionary = snapshoot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshoot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func fetchLike(forUser user : User , completion: @escaping([Post]) -> Void ) {
        var posts = [Post]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshoot in
            let postID = snapshoot.key
            self.fetchPost(withPostID: postID) { likedPost in
                var post = likedPost
                post.didLike = true
                
                posts.append(post)
                completion(posts)
            }
        }
    }
    func likePost(post: Post, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = post.didLike ? post.likes - 1 : post.likes + 1
        REF_TWEETS.child(post.postID).child("likes").setValue(likes)
        
        if post.didLike {
            //unlike post
            REF_USER_LIKES.child(uid).child(post.postID).removeValue { (err,ref) in
                REF_POST_LIKES.child(post.postID).removeValue(completionBlock: completion)
            }
            
        } else {
            //like post
            REF_USER_LIKES.child(uid).updateChildValues([post.postID : 1]) {(err,ref) in
                REF_POST_LIKES.child(post.postID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    func checkIfUserLikedPost (_ post:Post, completion : @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(post.postID).observeSingleEvent(of: .value) { snapshoot in
            completion(snapshoot.exists())
        }
    }
}


