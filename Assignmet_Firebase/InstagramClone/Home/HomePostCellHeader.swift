//
//  HomePostHeader.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 8/8/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class HomePostCellHeader: UIView {
    
    var post: MyPost? {
        didSet {
            configureUser()
        }
    }
    
    private var padding: CGFloat = 8
    
    private let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "user")
        iv.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        iv.layer.borderWidth = 0.5
        iv.isUserInteractionEnabled  = true
        return iv
    }()
    
    private let usernameButton: UIButton = {
        let label = UIButton(type: .system)
        label.setTitleColor(.black, for: .normal)
        label.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        label.contentHorizontalAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(userProfileImageView)
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: padding, paddingLeft: padding, paddingBottom: padding, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        addSubview(usernameButton)
        usernameButton.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: bottomAnchor, paddingLeft: 8)
    }
    
    private func configureUser() {
        guard let post = post else { return }
        usernameButton.setTitle(post.userName, for: .normal)
        userProfileImageView.image = #imageLiteral(resourceName: "user")
    }
}




