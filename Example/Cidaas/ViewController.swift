//
//  ViewController.swift
//  Cidaas
//
//  Created by Cidaas on 08/23/2018.
//  Copyright (c) 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, CidaasLoaderDelegate {
    
    var cidaas = Cidaas.shared
    
    @IBOutlet var cidaasView: CidaasView!
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        cidaasView.loaderDelegate = self
        cidaasView.ENABLE_BACK_BUTTON = true
        cidaasView.setBackButtonAttributes(title: "BACK", textColor: UIColor.white, backgroundColor: UIColor.orange)
//        cidaasView.loginWithEmbeddedBrowser(delegate: self) {
//            switch $0 {
//                case .success(let result):
//                    print(result.data.access_token)
//                    break
//                case .failure(let errorResponse):
//                    print(errorResponse.errorMessage)
//                    break
//            }
//        }

        let fb = CidaasFacebook.shared
        fb.delegate = self
        fb.login(viewType: "login") {
            switch $0 {
                case .success(let successResponse):
                    let alert = UIAlertController(title: "Alert", message: successResponse.data.access_token, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                    break
                case .failure(let errorResponse):
                    print(errorResponse)
                    break
            }
        }
        
    }
    
    func showLoader() {
        CustomLoader.shared.showLoader(self.view, using: nil) { (hud) in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.shared.hideLoader(self.view)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        cidaasView.webView(webView, didStartProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        cidaasView.webView(webView, didFail: navigation, withError: error)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        cidaasView.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        cidaasView.webView(webView, didFinish: navigation)
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
