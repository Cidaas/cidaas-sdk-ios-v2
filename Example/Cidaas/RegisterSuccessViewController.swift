//
//  RegisterSuccessViewController.swift
//  SDKCheck
//
//  Created by ganesh on 18/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import UIKit

class RegisterSuccessViewController: UIViewController {

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
