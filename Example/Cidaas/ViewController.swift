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

    var requestId: String = ""
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // did receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginAction(_ sender: Any) {
        
        Cidaas.shared.loginWithSocial(provider: "linkedin", delegate: self) {
            switch $0 {
            case .success(let loginSuccessResponse):
                print(loginSuccessResponse.data.access_token)
                break
            case .failure(let loginErrorResponse):
                print(loginErrorResponse.errorMessage)
                break
            }
        }
        
//        Cidaas.shared.loginWithBrowser(delegate: self) {
//            switch $0 {
//            case .failure(let errorResponse):
//                print(errorResponse.errorMessage)
//                break
//            case .success(let successResponse):
//                let alert = UIAlertController(title: "Access Token", message: "\(successResponse.data.access_token)", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                break
//            }
//        }
        
//        guard let url = URL(string: "https://stackoverflow.com") else { return }
//        UIApplication.shared.open(url)
        
    }
}
