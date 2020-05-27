//
//  ViewController.swift
//  Cidaas
//
//  Created by Cidaas on 08/23/2018.
//  Copyright (c) 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import AuthenticationServices

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    var cidaas = Cidaas.shared
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func login(_ sender: Any) {
        cidaas.loginWithBrowser(delegate: self) {
            switch $0 {
                case .success(let successResponse):
                    // your success code here
                    print("Access Token - \(successResponse.data.access_token)")
                    break
                case .failure(let error):
                    // your failure code here
                    print("Error - \(error.errorMessage)")
                    break
            }
        }
    }
    
    @available(iOS 12.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
}
