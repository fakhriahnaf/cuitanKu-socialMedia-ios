//
//  ActionSheetCell.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 07/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class ActionSheetCell : UITableViewCell {
    //MARK : - PROPERTIES
    
    var option: ActionSheetOptions? {
        didSet { configure() }
    }
    
    private let optionImageVIew: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "cuitankuLogo")
    
        return iv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test View"
        return label
    }()
    
    //MARK : - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageVIew)
        optionImageVIew.centerY(inView: self)
        optionImageVIew.anchor(left: leftAnchor , paddingLeft: 8)
        optionImageVIew.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageVIew.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK : - HELPERS
    
    func configure() {
        titleLabel.text = option?.description
    }
}
