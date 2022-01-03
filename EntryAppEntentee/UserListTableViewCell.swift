//
//  UserListTableViewCell.swift
//  EntryAppEntentee
//
//  Created by Jan Mikulášek on 27.12.2021.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    let masterStackView = UIStackView()
    let textStackView = UIStackView()
    
    let firstNameLabel = UILabel()
    let lastNameLabel = UILabel()
    let titleLabel = UILabel()
    let userImage = UIImageView()
    
    var portrait = [NSLayoutConstraint]()
    var landscape = [NSLayoutConstraint]()
    
    let estimatedCellSize = 80.0
    
    //MARK: - Cell init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        firstNameLabel.textAlignment = .left
        firstNameLabel.textColor = .black
        firstNameLabel.font = firstNameLabel.font.withSize(26)
        
        lastNameLabel.textAlignment = .left
        lastNameLabel.textColor = .gray
        lastNameLabel.font = firstNameLabel.font.withSize(18)
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = .gray
        titleLabel.font = firstNameLabel.font.withSize(14)
        
        textStackView.distribution = .fillProportionally
        textStackView.alignment = .fill
        
        masterStackView.distribution = .fillProportionally
        masterStackView.axis = .horizontal
        
        userImage.image = UIImage.init(systemName: "hourglass.circle")
        
        self.contentView.addSubview(masterStackView)
        masterStackView.addSubview(userImage)
        masterStackView.addSubview(textStackView)
        [firstNameLabel,lastNameLabel,titleLabel].forEach({ textStackView.addSubview($0)})
        
        backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - AutoLayout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createAutoLayout()
        userImage.makeRounded(radius: estimatedCellSize/2)
        layoutIfNeeded()
    
        
    }
  
    
    private func createAutoLayout() {
        
        NSLayoutConstraint.deactivate(portrait)
        NSLayoutConstraint.deactivate(landscape)
        
        portrait
        = masterStackView.anchorList(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
        + textStackView.anchorList(top: masterStackView.topAnchor, leading: userImage.trailingAnchor, bottom: masterStackView.bottomAnchor, trailing: masterStackView.trailingAnchor)
        
        + userImage.anchorList(top: masterStackView.topAnchor, leading: masterStackView.leadingAnchor, bottom: masterStackView.bottomAnchor, trailing: textStackView.leadingAnchor,padding: .init(top: 20, left: 0, bottom: 20, right: 0),size: .init(width: estimatedCellSize, height: estimatedCellSize))
        
        + firstNameLabel.anchorList(top: nil, leading: textStackView.leadingAnchor, bottom: nil, trailing: textStackView.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 0))
        
        + lastNameLabel.anchorList(top: firstNameLabel.bottomAnchor, leading: textStackView.leadingAnchor, bottom: nil, trailing: textStackView.trailingAnchor, centerY: textStackView.centerYAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 0))
        
        + titleLabel.anchorList(top: lastNameLabel.bottomAnchor, leading: textStackView.leadingAnchor, bottom: nil, trailing: textStackView.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 0))
        
        landscape
        = masterStackView.anchorList(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
        + textStackView.anchorList(top: masterStackView.topAnchor, leading: userImage.trailingAnchor, bottom: masterStackView.bottomAnchor, trailing: masterStackView.trailingAnchor)
        
        + userImage.anchorList(top: masterStackView.topAnchor, leading: masterStackView.leadingAnchor, bottom: masterStackView.bottomAnchor, trailing: textStackView.leadingAnchor,padding: .init(top: 20, left: 0, bottom: 20, right: 0),size: .init(width: estimatedCellSize, height: estimatedCellSize))
        
        + firstNameLabel.anchorList(top: nil, leading: textStackView.leadingAnchor, bottom: nil, trailing: textStackView.trailingAnchor, padding: .init(top: 0, left: 100, bottom: 0, right: 0))
        
        + lastNameLabel.anchorList(top: firstNameLabel.bottomAnchor, leading: textStackView.leadingAnchor, bottom: nil, trailing: textStackView.trailingAnchor, centerY: textStackView.centerYAnchor, padding: .init(top: 0, left: 100, bottom: 0, right: 0))
        
        + titleLabel.anchorList(top: lastNameLabel.bottomAnchor, leading: textStackView.leadingAnchor, bottom: nil, trailing: textStackView.trailingAnchor, padding: .init(top: 0, left: 100, bottom: 0, right: 0))
        
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(landscape)
        } else {
            NSLayoutConstraint.activate(portrait)
        }
        
    }
    
    
    
    
}
