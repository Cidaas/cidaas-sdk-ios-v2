//
//  ViewController.swift
//  Cidaas
//
//  Created by Cidaas on 08/23/2018.
//  Copyright (c) 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas

class ViewController: UIViewController {

    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // did receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginAction(_ sender: Any) {
        Cidaas.shared.loginWithBrowser(delegate: self) {
            switch $0 {
            case .failure(let errorResponse):
                print(errorResponse.errorMessage)
                break
            case .success(let successResponse):
                print(successResponse.data.access_token)
                break
            }
        }
        
    }
}

