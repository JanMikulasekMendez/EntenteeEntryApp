//
//  UserPostCollectionViewCell.swift
//  EntryAppEntentee
//
//  Created by Jan Mikulášek on 30.12.2021.
//

import UIKit

class UserPostCollectionViewCell: UICollectionViewCell {
    
    
    var portrait = [NSLayoutConstraint]()
    var landscape = [NSLayoutConstraint]()
    
    var postImage = UIImageView()
    var dateLabel = UILabel()
    var thumbsUpImage = UIImageView()
    var thumbsUpLabel = UILabel()
    
    //MARK: Cell Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        postImage.image = UIImage.init(systemName: "hourglass.circle")
        postImage.tintColor = .black
        
        thumbsUpImage.image = UIImage.init(systemName: "hand.thumbsup")
        thumbsUpImage.tintColor = .black
        
        dateLabel.textAlignment = .center
            
        contentView.addSubview(postImage)
        contentView.addSubview(thumbsUpImage)
        contentView.addSubview(thumbsUpLabel)
        contentView.addSubview(dateLabel)
        
       }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - AutoLayout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createLayout()
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 10
        postImage.contentMode = .scaleAspectFill
        postImage.tintColor = .black
        layoutIfNeeded()
        
    }
    
    private func createLayout() {
        NSLayoutConstraint.deactivate(portrait)
        NSLayoutConstraint.deactivate(landscape)
        
        portrait
        = postImage.anchorList(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: dateLabel.topAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
        
        + thumbsUpImage.anchorList(top: dateLabel.bottomAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: thumbsUpLabel.leadingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10),size: .init(width: 30, height: 30))
        
        + thumbsUpLabel.anchorList(top: dateLabel.bottomAnchor, leading: thumbsUpImage.trailingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 10),size: .init(width: 30, height: 30))
        
        + dateLabel.anchorList(top: postImage.bottomAnchor, leading: contentView.leadingAnchor, bottom: thumbsUpImage.topAnchor, trailing: contentView.trailingAnchor,size: .init(width: contentView.frame.width, height: 30))
        
        landscape
        = portrait
        
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(landscape)
        } else {
            NSLayoutConstraint.activate(portrait)
        }
    }
    
}
