//
//  ViewController.swift
//  Cidaas
//
//  Created by Cidaas on 08/23/2018.
//  Copyright (c) 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import LocalAuthentication
import AuthenticationServices

class ViewController: UIViewController, CidaasLoaderDelegate {
    
    var cidaas = Cidaas.shared
    var facebook = CidaasFacebook.shared
    let authenticatedContext = LAContext()
    var error: NSError?
    
    @IBOutlet var cidaasView: CidaasView!
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        cidaasView.loaderDelegate = self
        cidaasView.ENABLE_BACK_BUTTON = true
        cidaasView.setBackButtonAttributes(title: "BACK", textColor: UIColor.white, backgroundColor: UIColor.orange)
        facebook.delegate = self
        getRequestId()
        
    }
    
    func showLoader() {
        CustomLoader.shared.showLoader(self.view, using: nil) { (hud) in
            
        }
    }
    
    func logout(accessToken: String) {
        cidaasView.logout(accessToken: accessToken)
    }
    
    func hideLoader() {
        CustomLoader.shared.hideLoader(self.view)
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
//                    self.loginWithBrowser()
                    self.facebookLogin()
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
    
    func facebookLogin() {
        self.facebook.login(viewType: "login") {
            switch $0 {
            case .success(let clientInfoSuccessResponse):
                print(clientInfoSuccessResponse.data.access_token)
                break
            case .failure(let clientInfoFailureResponse):
                print(clientInfoFailureResponse.errorMessage)
                break
            }
        }
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
