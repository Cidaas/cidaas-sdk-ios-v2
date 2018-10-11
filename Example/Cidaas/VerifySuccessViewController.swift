//
//  VerifySuccessViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 27/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class VerifySuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
