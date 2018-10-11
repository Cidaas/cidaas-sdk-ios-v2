//
//  LoginWithEmailViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 07/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SCLAlertView
import Cidaas

class LoginWithEmailViewController: UIViewController {

    @IBOutlet var txtCode: CustomTextField!
    
    // local variables
    var cidaas = Cidaas.shared
    var requestId: String = ""
    var sub: String = ""
    var trackId: String = ""
    var statusId: String = ""
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginWithEmail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func verifyCodeBtn(_ sender: Any) {
        
        if txtCode.text == "" {
            return
        }
        verifyCode()
    }
    
    // login with email
    func loginWithEmail() {
        // show loader
        self.showLoader()
        
        let passwordlessEntity = PasswordlessEntity()
        passwordlessEntity.requestId = requestId
        passwordlessEntity.sub = sub
        passwordlessEntity.trackId = trackId
        passwordlessEntity.usageType = UsageTypes.MFA.rawValue
        
        // login with email API
        cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
            switch($0) {
            case .failure(let error):
                print("ERROR : \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("Response : \(response.data)")
                
                self.statusId = response.data.statusId
                
                // hide loader
                self.hideLoader()
            }
        }
    }
    
    // verify code
    func verifyCode() {
        // show loader
        self.showLoader()
        
        let passwordlessEntity = PasswordlessEntity()
        passwordlessEntity.requestId = requestId
        passwordlessEntity.sub = sub
        passwordlessEntity.trackId = trackId
        passwordlessEntity.usageType = UsageTypes.MFA.rawValue
        
        // verify code API
        cidaas.verifyEmail(statusId: statusId, code: txtCode.text!) {
            switch($0) {
            case .failure(let error):
                print("ERROR : \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("Response : \(response.data)")
                
                self.userDefaults.set(response.data.sub, forKey: "sub")
                self.userDefaults.synchronize()
                
                // hide loader
                self.hideLoader()
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
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
