//
//  UserProfileViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 05/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Cidaas

class UserProfileViewController: UIViewController {

    @IBOutlet var lbl_firstName: UILabel!
    @IBOutlet var lbl_lastName: UILabel!
    @IBOutlet var lbl_email: UILabel!
    
    var sub: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user info
        getUserInfo()
    }

    func getUserInfo() {
        
        // show loader
        self.showLoader()
        
        Cidaas.shared.getUserInfo(sub: sub) {
            switch $0 {
                case .failure(let error):
                    
                    // hide loader
                    self.hideLoader()
                    
                    print(error.errorMessage)
                case .success(let response):
                    self.lbl_firstName.text = response.given_name
                    self.lbl_lastName.text = response.family_name
                    self.lbl_email.text = response.email
                
                    // hide loader
                    self.hideLoader()
            }
        }
    }
    
    func showLoader() {
        CustomLoader.sharedCustomLoaderInstance.showLoader(self.view, using: nil) { _ in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.sharedCustomLoaderInstance.hideLoader(self.view)
    }
}
