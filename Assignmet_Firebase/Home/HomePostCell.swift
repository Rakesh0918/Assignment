//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 7/28/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    var post: MyPost? {
        didSet {
            configurePost()
        }
    }
    let header = HomePostCellHeader()
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let postCreatetionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    let padding: CGFloat = 12
    
    private let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return iv
    }()
    
    static var cellId = "homePostCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(header)
        header.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        addSubview(photoImageView)
        photoImageView.anchor(top: header.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        setupActionButtons()
    }
    
    private func setupActionButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(captionLabel)
        stackView.addArrangedSubview(postCreatetionLabel)
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, paddingTop: padding, paddingLeft: padding)
        
       
    }
    
    private func configurePost() {
        guard let post = post else { return }
        header.post = post
        captionLabel.text = post.postDescription
        print(post.postCreationDate)
        postCreatetionLabel.text = formatDate(dateString: post.postCreationDate)
        guard let imageUrl = URL(string: post.imageUrls.first ?? "") else { return }
         downloadImage(from: imageUrl) { image in
             if let image = image {
                 // Use the downloaded image
                 DispatchQueue.main.async {
                     self.photoImageView.image = image
                 }
             } else {
                 // Handle error or fallback
                 print("Failed to download image")
             }
         }
    }

}
