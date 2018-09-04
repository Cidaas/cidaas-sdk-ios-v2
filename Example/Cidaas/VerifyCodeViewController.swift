//
//  VerifyCodeViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 27/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Cidaas
import SDWebImage
import SCLAlertView

class VerifyCodeViewController: UIViewController {
    
    @IBOutlet var logourl: UIImageView!
    @IBOutlet var code: CustomTextField!
    
    // local variables
    var cidaas = Cidaas.shared
    var accvid: String = ""
    var logo_uri: UIImage = UIImage(named: "app-logo")!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.logourl.image = self.logo_uri
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func VerifyCodeClick(_ sender: Any) {
        // show loader
        self.showLoader()
        
        // get initiate email verification API
        cidaas.verifyAccount(accvid: self.accvid, code: code.text ?? "") {
            switch($0) {
            case .failure(let error):
                self.showAlert(message: error.errorMessage, style: .info)
                
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("SUCCESS : \(response.success)")
                
                // hide loader
                self.hideLoader()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifySuccessViewController") as! VerifySuccessViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
