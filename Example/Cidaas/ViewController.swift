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
        
        scanned(exchange_id: "41cac32f-bf5e-4199-90da-a1794c62f5fa")
//     enroll(exchange_id: "dd54df80-bd28-4eda-99fb-d66dbeed8208")
//        pushAcknowledge(exchange_id: "0cd6caec-24d0-4930-b282-7686f1c7f9cf")
        
    }
    
    func getTotp() {
        var url="otpauth://totp/Cidaas%20Developers:Ganesh%20Kumar?issuer=test&secret=KNJC6SSXHBXVGUSDMY2CMYJEJRZWMJDJ"
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            var totp = TOTPVerificationController.shared.gettingTOTPCode(url: URL(string: url)!)
            print(totp.totp_string + " - " + totp.timer_count)
        }
    }
    
    
    func scanned(exchange_id: String) {
        let incomingData = ScannedRequest()
        incomingData.client_id = "938c570e-7728-4fa3-b62f-5167f722c788"
        incomingData.exchange_id = exchange_id
        incomingData.sub = "93f68178-0d42-4f4e-896d-c758c71ccffa"
        
        Cidaas.shared.setFCMToken(fcmToken: "cS7fVZg5hFs:APA91bFKbzKiS18c46YLA8XNq71gVZQ2mWGGnkkwAFRp3kJshvhMaITLpc4Oa-jWJueU-r64J47l-6jwWS2zDIF97u1uUxOBqv7EwBsyxkror_sxSSthIMYc_9ClJdmjpoL6PzIxs1wL")
        
        Cidaas.verification.scanned(verificationType: VerificationTypes.PATTERN.rawValue, scannedRequest: incomingData) {
            switch $0 {
            case .success(let result):
                print(result.data.exchange_id.exchange_id)
//                self.enroll(exchange_id: result.data.exchange_id.exchange_id)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func enroll(exchange_id: String) {
        let incomingData = EnrollRequest()
        incomingData.client_id = "938c570e-7728-4fa3-b62f-5167f722c788"
        incomingData.exchange_id = exchange_id
        incomingData.pass_code = "RED-1234"
        
        Cidaas.verification.enroll(verificationType: VerificationTypes.PATTERN.rawValue, enrollRequest: incomingData) {
            switch $0 {
            case .success(let result):
                print(result.data.exchange_id.exchange_id)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func pushAcknowledge(exchange_id: String) {
        let incomingData = PushAcknowledgeRequest()
        incomingData.client_id = "938c570e-7728-4fa3-b62f-5167f722c788"
        incomingData.exchange_id = exchange_id
        
        Cidaas.shared.setFCMToken(fcmToken: "cS7fVZg5hFs:APA91bFKbzKiS18c46YLA8XNq71gVZQ2mWGGnkkwAFRp3kJshvhMaITLpc4Oa-jWJueU-r64J47l-6jwWS2zDIF97u1uUxOBqv7EwBsyxkror_sxSSthIMYc_9ClJdmjpoL6PzIxs1wL")
        
        Cidaas.verification.pushAcknowledge(verificationType: VerificationTypes.PATTERN.rawValue, pushAckRequest: incomingData) {
            switch $0 {
            case .success(let result):
                self.pushAllow(exchange_id: result.data.exchange_id.exchange_id)
                print(result)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func pushAllow(exchange_id: String) {
        let incomingData = PushAllowRequest()
        incomingData.client_id = "938c570e-7728-4fa3-b62f-5167f722c788"
        incomingData.exchange_id = exchange_id
        
        Cidaas.shared.setFCMToken(fcmToken: "cS7fVZg5hFs:APA91bFKbzKiS18c46YLA8XNq71gVZQ2mWGGnkkwAFRp3kJshvhMaITLpc4Oa-jWJueU-r64J47l-6jwWS2zDIF97u1uUxOBqv7EwBsyxkror_sxSSthIMYc_9ClJdmjpoL6PzIxs1wL")
        
        Cidaas.verification.pushAllow(verificationType: VerificationTypes.PATTERN.rawValue, pushAllowRequest: incomingData) {
            switch $0 {
            case .success(let result):
                self.authenticate(exchange_id: result.data.exchange_id.exchange_id)
                print(result)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func authenticate(exchange_id: String) {
        let incomingData = AuthenticateRequest()
        incomingData.client_id = "938c570e-7728-4fa3-b62f-5167f722c788"
        incomingData.exchange_id = exchange_id
        incomingData.pass_code = "RED-1234"
        
        Cidaas.shared.setFCMToken(fcmToken: "cS7fVZg5hFs:APA91bFKbzKiS18c46YLA8XNq71gVZQ2mWGGnkkwAFRp3kJshvhMaITLpc4Oa-jWJueU-r64J47l-6jwWS2zDIF97u1uUxOBqv7EwBsyxkror_sxSSthIMYc_9ClJdmjpoL6PzIxs1wL")
        
        Cidaas.verification.authenticate(verificationType: VerificationTypes.PATTERN.rawValue, authenticateRequest: incomingData) {
            switch $0 {
            case .success(let result):
                print(result)
                break
            case .failure(let error):
                print(error)
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
