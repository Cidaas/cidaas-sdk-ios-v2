//
//  ViewController.swift
//  Cidaas
//
//  Created by Cidaas on 08/23/2018.
//  Copyright (c) 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import SDWebImage
import SCLAlertView

class ViewController: UIViewController {
    
    // outlets
    @IBOutlet var tenantName: UILabel!
    @IBOutlet var logourl: UIImageView!
    @IBOutlet var email: CustomTextField!
    @IBOutlet var password: CustomTextField!
    
    // local variables
    var cidaas = Cidaas.shared
    var requestId: String = ""
    var tenant_name: String = ""
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRequestId()
    }
    
    // did receive memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // getting request id
    func getRequestId() {
        // show loader
        self.showLoader()
        
        // get request id API
        cidaas.getRequestId() {
            switch($0) {
            case .failure(let error):
                print("ERROR: \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("REQUEST ID : \(response.data.requestId)")
                
                // hide loader
                self.hideLoader()
                
                // set request id
                self.requestId = response.data.requestId
                
                // call get client info
                self.getClientInfo(requestId: self.requestId)
            }
        }
    }
    
    // getting tenant info
    func getTenantInfo() {
        // show loader
        self.showLoader()
        
        // get tenant info API
        cidaas.getTenantInfo() {
            switch($0) {
            case .failure(let error):
                print("ERROR: \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("TENANT NAME : \(response.data.tenant_name)")
                print("ALLOW LOGIN WITH : \(response.data.allowLoginWith)")
                
                // hide loader
                self.hideLoader()
                
                // set tenant name
                self.tenant_name = response.data.tenant_name
                self.tenantName.text = "Login with \(response.data.tenant_name)"
            }
        }
    }
    
    // getting client info
    func getClientInfo(requestId: String) {
        // show loader
        self.showLoader()
        
        // get client info API
        cidaas.getClientInfo(requestId: requestId) {
            switch($0) {
            case .failure(let error):
                print("ERROR: \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("CLIENT NAME : \(response.data.client_name)")
                print("LOGO URL : \(response.data.logo_uri)")
                print("LOGIN PROVIDERS : \(response.data.login_providers)")
                print("PASSWORDLESS ENABLED : \(response.data.passwordless_enabled)")
                print("POLICY URL : \(response.data.policy_uri)")
                print("TERMS OF USE URL : \(response.data.tos_uri)")
                
                // set logo url
                if (response.data.logo_uri != "") {
                    self.logourl.sd_setImage(with: URL(string: response.data.logo_uri), completed: { (image, error, type, url) in
                        DispatchQueue.main.async {
                            if image != nil {
                                self.logourl.image = image
                            }
                            else {
                                self.logourl.image = UIImage(named: "app-logo")
                            }
                        }
                    })
                }
                else {
                    self.logourl.image = UIImage(named: "app-logo")
                }
                
                // hide loader
                self.hideLoader()
                
                // call get tenant info
                self.getTenantInfo()
            }
        }
    }
    
    // login submit
    @IBAction func login(_ sender: Any) {
        
        // construct an object
        let loginEntity = LoginEntity()
        loginEntity.username = email.text ?? ""
        loginEntity.password = password.text ?? ""
        
        // show loader
        self.showLoader()
        
        // call login with credentials API
        cidaas.loginWithCredentials(requestId: self.requestId, loginEntity: loginEntity) {
            switch($0) {
            case .failure(let error):
                
                // hide loader
                self.hideLoader()
                
                if (error.errorMessage == "ConsentRequired") {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConsentManagementViewController") as! ConsentManagementViewController
                    let consentError = error.error as! LoginErrorResponseDataEntity
                    vc.consent_name = consentError.consent_name
                    vc.sub = consentError.sub
                    vc.track_id = consentError.track_id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if (error.errorMessage == "user_not_verified") {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnverifiedUserViewController") as! UnverifiedUserViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.showAlert(message: error.errorMessage, style: .info)
                }
            case .success(let response):
                print("ACCESS TOKEN : \(response.data.access_token)")
                print("EXPIRES IN : \(response.data.expires_in)")
                print("ID TOKEN : \(response.data.id_token)")
                print("ID TOKEN EXPIRES IN : \(response.data.id_token_expires_in)")
                print("REFRESH TOKEN : \(response.data.refresh_token)")
                print("TOKEN TYPE : \(response.data.token_type)")
                print("SUB : \(response.data.sub)")
                
                // hide loader
                self.hideLoader()
            }
        }
    }
    
    // register
    @IBAction func register(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.requestId = self.requestId
        vc.tenant_name = "Register with \(self.tenant_name)"
        vc.logo_uri = self.logourl.image!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // show alert
    func showAlert(title: String = "Warning", message: String, style: SCLAlertViewStyle) {
        
        var colorStyle : UInt = 0xFD9226
        
        if (style == .info) {
            colorStyle = 0xFD9226
        }
        else if (style == .success) {
            colorStyle = 0x2DB475
        }
        
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: message, // String of view
            style: style, // Styles - see below.
            closeButtonTitle: "OK",
            colorStyle: colorStyle,
            colorTextButton: 0xFFFFFF
        )
    }
    
    func showLoader() {
        CustomLoader.sharedCustomLoaderInstance.showLoader(self.view, using: nil) { _ in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.sharedCustomLoaderInstance.hideLoader(self.view)
    }

}

