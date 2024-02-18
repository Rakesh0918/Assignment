//
//  User.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 7/30/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let mobile: String?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.mobile = dictionary["mobile"] as? String ?? nil
    }
}
