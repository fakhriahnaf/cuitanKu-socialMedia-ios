//
//  InputTextView.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 25/08/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class InputTextView : UITextView {
    
    //MARK : - PROPERTIES
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "whats happend?"
        return label
    }()
    
    //MARK :- LIFECYCLE
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame : frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK :- SELECTOR
    @objc func handleInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
