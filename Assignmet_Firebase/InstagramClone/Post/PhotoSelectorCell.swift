//
//  PhotoSelectorCell.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 7/27/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Initially hidden
        return imageView
    }()
    
    static var cellId = "photoSelectorCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
 
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // Apply faded blue overlay for selected cells
                backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            } else {
                backgroundColor = .clear
            }
        }
    }
    
    private func sharedInit() {
        addSubview(photoImageView)
        addSubview(checkmarkImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        checkmarkImageView.anchor(top: photoImageView.topAnchor, left: photoImageView.leftAnchor, width: 24, height: 24)
    }
}
