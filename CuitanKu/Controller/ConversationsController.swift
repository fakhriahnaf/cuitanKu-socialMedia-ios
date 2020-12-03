//
//  ConversationsController.swift
//  CuitanKu
//
//  Created by Fakhri Ahnaf Dhia on 27/06/20.
//  Copyright © 2020 Fakhri Ahnaf Dhia. All rights reserved.
//

import UIKit

class ConversationsController: UIViewController {
    
    // MARK = - Propertis
    
    
    //Mark = - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

        
    }
    //buat navigasi atas Bar
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }

    
}
