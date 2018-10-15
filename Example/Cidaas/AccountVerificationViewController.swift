//
//  AccountVerificationViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 27/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Cidaas
import SDWebImage
import SCLAlertView

class AccountVerificationViewController: UIViewController {

    @IBOutlet var logourl: UIImageView!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var smsButton: UIButton!
    @IBOutlet var ivrButton: UIButton!
    
    // local variables
    var cidaas = Cidaas.shared
    var requestId: String = ""
    var sub: String = ""
    var logo_uri: UIImage = UIImage(named: "app-logo")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logourl.image = self.logo_uri
        self.getAccountVerificationList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // getting account verification list
    func getAccountVerificationList() {
        // show loader
        self.showLoader()
        
        // get account verification list API
        cidaas.getAccountVerificationList(sub: sub) {
            switch($0) {
            case .failure(let error):
                print("ERROR : \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("EMAIL VERIFIED : \(response.data.EMAIL)")
                print("MOBILE VERIFIED : \(response.data.MOBILE)")

                // hide loader
                self.hideLoader()
                
                if (response.data.EMAIL == false) {
                    self.emailButton.isEnabled = true
                }
                else {
                    self.emailButton.isEnabled = false
                }
                if (response.data.MOBILE == false) {
                    self.smsButton.isEnabled = true
                    self.ivrButton.isEnabled = true
                }
                else {
                    self.smsButton.isEnabled = false
                    self.ivrButton.isEnabled = false
                }
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
    @IBAction func EmailClick(_ sender: Any) {
        // show loader
        self.showLoader()
        
        // get initiate email verification API
        cidaas.initiateEmailVerification(requestId: self.requestId, sub: self.sub) {
            switch($0) {
            case .failure(let error):
                self.showAlert(message: error.errorMessage, style: .info)
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("ACCVID : \(response.data.accvid)")
                
                // hide loader
                self.hideLoader()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyCodeViewController") as! VerifyCodeViewController
                vc.accvid = response.data.accvid
                vc.logo_uri = self.logourl.image!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func SMSClick(_ sender: Any) {
        // show loader
        self.showLoader()
        
        // get initiate sms verification API
        cidaas.initiateSMSVerification(requestId: self.requestId, sub: self.sub) {
            switch($0) {
            case .failure(let error):
                self.showAlert(message: error.errorMessage, style: .info)
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("ACCVID : \(response.data.accvid)")
                
                // hide loader
                self.hideLoader()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyCodeViewController") as! VerifyCodeViewController
                vc.accvid = response.data.accvid
                vc.logo_uri = self.logourl.image!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func IVRClick(_ sender: Any) {
        // show loader
        self.showLoader()
        
        // get initiate ivr verification API
        cidaas.initiateIVRVerification(requestId: self.requestId, sub: self.sub) {
            switch($0) {
            case .failure(let error):
                self.showAlert(message: error.errorMessage, style: .info)
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("ACCVID : \(response.data.accvid)")
                
                // hide loader
                self.hideLoader()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyCodeViewController") as! VerifyCodeViewController
                vc.accvid = response.data.accvid
                vc.logo_uri = self.logourl.image!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
