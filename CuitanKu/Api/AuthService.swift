//
//  AuthService.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 30/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email :String
    let password : String
    let fullname : String
    let username : String
    let profileImage : UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func loginUser(withEmail email: String , password : String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion )
        
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username

        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) {(meta, error)in
            storageRef.downloadURL{ (url, error)in
                guard let profileImageUrl = url?.absoluteString else {return}
                Auth.auth().createUser(withEmail: email, password: password) {(result, error) in if let error = error {
                        print("DEBUG: Eror is \(error.localizedDescription)")
                        return
                    }

                    guard let uid = result?.user.uid else {return}
                    let values = [  "email" : email,
                                    "username" : username,
                                    "fullname" : fullname,
                                    "profileImageUrl": profileImageUrl ]

                    REF_USER.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
