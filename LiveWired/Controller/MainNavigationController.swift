//
//  MainNavigationController.swift
//  LiveWired
//
//  Created by Mostafa Hakam on 2017-10-16.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
    }
    
    private func setupNavigationBarItems() {
        
        // Logo display
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "LogoIcon") )
        titleImageView.frame = CGRect(x:0, y:0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        // Logout button
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage( #imageLiteral(resourceName: "Logout"), for: .normal)
        logoutButton.frame = CGRect(x:0, y:0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        // Menu button
        let menuButton = UIButton(type: .system)
        menuButton.setImage( #imageLiteral(resourceName: "Menu"), for: .normal)
        menuButton.frame = CGRect(x:0, y:0, width: 34, height: 34)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        // Customize nav bar
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
    }
}

