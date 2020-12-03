//
//  NotificationService.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 11/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(toUser user: User,
                            type : NotificationType,
                            postID: String? = nil ) {
        //print("DEBUG : TYPE IS \(type)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values : [String : Any] = ["timestamp" : Int(NSDate().timeIntervalSince1970), "uid": uid, "type": type.rawValue]
        
        if type == .metion {
            guard let postID = postID else { return }
            values["postID"] = postID
        }
        
        if let postID = postID {
            values["postID"] = postID
        }
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    fileprivate func getNotifications(uid: String ,completion : @escaping([Notification])-> Void) {
        var notifications = [Notification]()
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshoot in
            guard let dictionary = snapshoot.value as? [String : AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
    
    func fetchNotifications(completion : @escaping([Notification]) -> Void) {
        let notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //make sure about notification exist notification
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value){ snapshoot in
            if !snapshoot.exists() {
                //this user has notification
                completion(notifications)
            } else {
                self.getNotifications(uid: uid, completion: completion)
            }
        }
    }
}
