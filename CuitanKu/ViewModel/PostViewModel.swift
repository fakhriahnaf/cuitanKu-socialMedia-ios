//
//  PostViewModel.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 04/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class PostViewModel {
    let post : Post
    let user : User
    
    
    var profileImageUrl :URL? {
        return post.user.profilImageUrl
    }
    var timestamp : String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: post.timestamp , to: now ) ?? "2m"
    }
    
    var usernameText : String {
        return "@\(user.username)"
    }
    
    var headerTimeStamp : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a - dd/MM/yyyy"
        return formatter.string(from: post.timestamp)
    }
    
    var retweetsAttributedString : NSAttributedString? {
        return attributedText(withValue : post.reetweetCount, text : "Retweets")
    }
    
    var likesAttributedString : NSAttributedString? {
        return attributedText(withValue : post.likes, text : "Likes")
    }
    
    var userInfoText :NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)] )
        
        title.append(NSAttributedString(string: "@\(user.username)",
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " .\(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        
        //print("DEBUG: date of post is \(timestamp)")
        return title
    }
    
    var likeButtonTintColor : UIColor {
        return post.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = post.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel : Bool {
        return !post.isReply
    }
    
    var replyText : String? {
        return "replying to @\(user.username)"
//        guard let replyingToUsername = post.replyingTo else { return nil }
//        return "-> replying to @\(replyingToUsername)"
    }
    
    
    //MARK :- LIFECYCLE
    
    
    init (post: Post){
        self.post = post
        self.user = post.user
    }
    fileprivate func attributedText(withValue value : Int, text : String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [ .font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = post.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
}
