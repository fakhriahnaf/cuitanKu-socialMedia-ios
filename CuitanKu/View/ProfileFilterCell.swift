//
//  ProfileFilterCell.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 06/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //MARK - PROPERTIES
    
    var option : ProfileFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Label"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .cuitankuTosca : .lightGray
        }
    }
    //MARK -LIFESCYCLE
    
    override init (frame :CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
