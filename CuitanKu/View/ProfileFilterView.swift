//
//  ProfileFilterView.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 06/07/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class ProfileFilterView : UIView {
    
    //MARK - PROPERTIES
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        //cv.delegate = self
        //cv.dataSource = self
        return cv
    }()
    
    //MARK - LIFESCYCLE
    override init (frame : CGRect) {
        super.init(frame:frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//extension ProfileFilterView : UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        Int {
//            return 3
//        }
//    func collectionView(_ collectio)
//    }
//}
