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
    
    var cidaas = Cidaas.shared
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRequestId()
    }
    
    // did receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // login with browser
    func loginWithBrowser() {
        self.cidaas.loginWithBrowser(delegate: self) {
            switch $0 {
            case .success(let loginSuccessResponse):
                print(loginSuccessResponse.data.access_token)
                break
            case .failure(let loginFailureResponse):
                print(loginFailureResponse.errorMessage)
                break
            }
        }
    }
    
    // get request id
    func getRequestId() {
        self.cidaas.getRequestId() {
            switch $0 {
                case .success(let requestIdSuccessResponse):
                    print(requestIdSuccessResponse.data.requestId)
                    self.loginWithBrowser()
                    break
                case .failure(let requestIdFailureResponse):
                    print(requestIdFailureResponse.errorMessage)
                    break
            }
        }
    }
    
    // get tenant information
    func getTenantInformation() {
        self.cidaas.getTenantInfo() {
            switch $0 {
            case .success(let tenantInfoSuccessResponse):
                print(tenantInfoSuccessResponse.data.tenant_name)
                break
            case .failure(let tenantInfoFailureResponse):
                print(tenantInfoFailureResponse.errorMessage)
                break
            }
        }
    }
    
    // get client information
    func getClientInformation() {
        self.cidaas.getClientInfo() {
            switch $0 {
            case .success(let clientInfoSuccessResponse):
                print(clientInfoSuccessResponse.data.login_providers)
                break
            case .failure(let clientInfoFailureResponse):
                print(clientInfoFailureResponse.errorMessage)
                break
            }
        }
    }
}
