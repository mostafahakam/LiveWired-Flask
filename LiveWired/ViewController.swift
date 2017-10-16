//
//  ViewController.swift
//  LiveWired
//
//  Created by Mostafa Hakam on 2017-10-16.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutHandler(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

