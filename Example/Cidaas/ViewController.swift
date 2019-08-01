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
import LocalAuthentication

class ViewController: UIViewController, WKNavigationDelegate, CidaasLoaderDelegate {
    
    var cidaas = Cidaas.shared
    let authenticatedContext = LAContext()
    var error: NSError?
    
    @IBOutlet var cidaasView: CidaasView!
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        cidaasView.loaderDelegate = self
        cidaasView.ENABLE_BACK_BUTTON = true
        cidaasView.enableNativeFacebook = true
        cidaasView.enableNativeGoogle = true
        cidaasView.setBackButtonAttributes(title: "BACK", textColor: UIColor.white, backgroundColor: UIColor.orange)
        CidaasFacebook.shared.delegate = self
        CidaasGoogle.shared.delegate = self
//        cidaasView.loginWithEmbeddedBrowser(delegate: self) {
//            switch $0 {
//                case .success(let result):
//                    break
//                case .failure(let error):
//                    break
//            }
//        }
//        getRequestId()
        
//        getTotp()
        
//    pushAcknowledge(exchange_id: "461c0dae-a11c-4e4c-adbb-250128295933")
        
        getRequestId()
        
        
//        scanned(exchange_id: "41cac32f-bf5e-4199-90da-a1794c62f5fa")
//     enroll(exchange_id: "dd54df80-bd28-4eda-99fb-d66dbeed8208")
//        pushAcknowledge(exchange_id: "0cd6caec-24d0-4930-b282-7686f1c7f9cf")
    }
    
    func setup() {
        let setupRequest = ConfigureRequest()
        setupRequest.verificationType = "PATTERN"
        setupRequest.pass_code = "RED123"
        setupRequest.access_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ2M2ExOGU0LWI1NzMtNGJlNy1iYzM2LTNiM2RiMTUzNWExMiJ9.eyJzaWQiOiJhMmI4ZTlkZi00YzQ3LTRhYWQtYjRiNy00ZGU5NjYzNDcyYmEiLCJzdWIiOiI0OWViNTBlOS1jZjBhLTQxNDgtYjc0NC03YzNiZjBmYzkyNDciLCJpc3ViIjoiMTc5MjYwMzAtMzRlZC00MTQ2LWFkYzktZDhkODUwZWIyZmVlIiwiYXVkIjoiYzE3YzZmMmEtNDcyOS00Y2YzLTg5NjMtNzZmYjNmYzBjYzQ5IiwiaWF0IjoxNTYxOTYzMjg1LCJhdXRoX3RpbWUiOjE1NjE5NjMyODUsImlzcyI6Imh0dHBzOi8vbmlnaHRseWJ1aWxkLmNpZGFhcy5kZSIsImp0aSI6IjViOTk1ZGM2LWE0Y2YtNDJmMy1iODVkLTYxZDc1OTRkYzM5NyIsInNjb3BlcyI6W10sInJvbGVzIjpbIlVTRVIiXSwiZ3JvdXBzIjpbeyJyb2xlcyI6WyJTRUNPTkRBUllfQURNSU4iXSwiX2lkIjoiODdlMzczYzUtYWI0NS00MDc1LTk2NmItMTdkM2JkYTM1M2RlIiwiZ3JvdXBJZCI6IkNJREFBU19BRE1JTlMiLCJpZCI6Ijg3ZTM3M2M1LWFiNDUtNDA3NS05NjZiLTE3ZDNiZGEzNTNkZSJ9XSwiZXhwIjoxNTYyMDQ5Njg1fQ.gs9U6c5GwrdyCMSbdzW7BRJdDQjmf0ipM_DiZV2ws7UBs_OcAWVviYv_hh0NDYElTyunfO7fKgEmnRL5JsrD2_doqZBwC20MsXBvEQTUbVvXEnXcrl51Ib0m-EobqSbTzJ0F_hI3GCRjexIvJoMjGs60ZCrxk0QleqJR5J4FAsU"
        
        cidaas.setFCMToken(sub: "", fcmToken: "eoR95tONqJQ:APA91bFRxFaVD1ZXUw_ThJ_3YoFxw97fgoYhlU0fXBP5arZ7IZ6-FNVPogbTw_-mEK8abV8Pl50-fcIitYwZAK8JN9IHdd8yL-pWpIV-C9l3MY-jHlZ9ITocjO3Z220NaqoY3twt2WU7")
        
        CidaasVerification.shared.configure(configureRequest: setupRequest) {
            switch $0 {
            case .success(let successResponse):
                print(successResponse.data.sub)
                break
            case .failure(let errorResponse):
                print(errorResponse.errorMessage)
                break
            }
        }
    }

    func authenticate(_ requestId: String) {
        let loginRequest = LoginRequest()
        loginRequest.request_id = requestId
        loginRequest.sub = "49eb50e9-cf0a-4148-b744-7c3bf0fc9247"
        loginRequest.usage_type = "PASSWORDLESS_AUTHENTICATION"
        loginRequest.verificationType = "PATTERN"
        loginRequest.pass_code = "RED123"
        
        cidaas.setFCMToken(sub: "", fcmToken: "eoR95tONqJQ:APA91bFRxFaVD1ZXUw_ThJ_3YoFxw97fgoYhlU0fXBP5arZ7IZ6-FNVPogbTw_-mEK8abV8Pl50-fcIitYwZAK8JN9IHdd8yL-pWpIV-C9l3MY-jHlZ9ITocjO3Z220NaqoY3twt2WU7")
        
        CidaasVerification.shared.login(loginRequest: loginRequest) {
            switch $0 {
            case .success(let successResponse):
                print(successResponse.data.sub)
                break
            case .failure(let errorResponse):
                print(errorResponse.errorMessage)
                break
            }
        }
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
//                    self.loginWithBrowser()
                    self.authenticate(requestIdSuccessResponse.data.requestId)
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
