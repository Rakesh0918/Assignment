//
//  Utils.swift
//  InstagramClone
//
//  Created by Rakesh Sharma on 18/02/24.
//  Copyright © 2024 Mac Gallagher. All rights reserved.
//

import UIKit


struct Utils {
    static var authVerificationID: String? {
        get {
            return UserDefaults.standard.value(forKey: "authVerificationID") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "authVerificationID")
        }
    }
    
    
    static func showToast(message: String, bgColor: UIColor = .red){
        DispatchQueue.main.async {
            Toast.show(message: message, bgColor: bgColor)
        }
    }
}
