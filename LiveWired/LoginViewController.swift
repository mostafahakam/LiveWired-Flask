//
//  LoginViewController.swift
//  LiveWired
//
//  Created by Mostafa Hakam on 2017-10-16.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    var mainTitle: UILabel!
    var LoginCredentials: UILabel!
    var proceed: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        view.backgroundColor = .black
        
        setupImage()
        setupLabels()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let mainNavigationController = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! MainNavigationController
        
        present(mainNavigationController, animated: true, completion: nil)
        
    }
    
    
    private func setupImage(){
        // Shaka image
        let imageName = "voice"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: (self.view.frame.size.width/2) - 90, y: 120, width: 180, height: 180)
        imageView.tintColor = UIColor.white
        view.addSubview(imageView)
    }
    
    
    private func setupLabels(){
        // Title label
        mainTitle = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 125, y: 300, width: 250, height: 50))
        mainTitle.text = "LiveWired"
        mainTitle.textAlignment = .center
        mainTitle.textColor = .white
        mainTitle.font = UIFont(name: "AmericanTypeWriter", size: 40)
        view.addSubview(mainTitle)
        
        // City Picker Title
        LoginCredentials = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - 125, y: 400, width: 250, height: 50))
        LoginCredentials.text = "Click below for your Recordings"
        LoginCredentials.textAlignment = .center
        LoginCredentials.textColor = .white
        LoginCredentials.font = UIFont(name: "Calibri", size: 20)
        view.addSubview(LoginCredentials)
        
    }
}

