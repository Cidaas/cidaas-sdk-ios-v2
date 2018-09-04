//
//  MFAListViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 28/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Cidaas
import SDWebImage
import SCLAlertView

class MFAListViewController: UIViewController {
    
    // local variables
    var cidaas = Cidaas.shared
    var requestId: String = ""
    var sub: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMFAList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // getting mfa list
    func getMFAList() {
        // show loader
        self.showLoader()
        
        // get mfa list API
        cidaas.getMFAList(sub: sub) {
            switch($0) {
            case .failure(let error):
                print("ERROR : \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("Response : \(response.data)")
                
                // hide loader
                self.hideLoader()
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
