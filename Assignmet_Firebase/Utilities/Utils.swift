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

struct Const {
    static let loginTitle = "Welcome\nTo\nOne30am"
    static let login = "Login"
    static let next = "Next"
    static let share = "Share"
    static let title = "One30am"
    static let donNottHaveAnAccount = "Don't have an account?  "
    static let signUP = "Sign Up"
    static let verify = "Verify"
    static let mobilePlaceholder = "Mobile"
    static let codePlaceholder = "Code"
    static let userNamePlaceholder = "Name"
    static let alreadyHaveAnAccount = "Already have an account?  "
    static let signIn = "Sign In"
    
}


struct Err {
    static let pleaseEnterValidCode = "Please enter valid code"
    static let failedToLogin = "Failed To login"
    static let userNotExistPleaaseSignUP = "User Not Exist Pleaase signUP"
    static let userNotExistPleaaseLogin = "User Exists Pleaase login"
    static let failedToCreateUser = "Failed To Create user"
}
