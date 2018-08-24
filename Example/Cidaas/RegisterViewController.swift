//
//  RegisterViewController.swift
//  SDKCheck
//
//  Created by ganesh on 17/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import SDWebImage
import SCLAlertView

class RegisterViewController: UIViewController {
    
    // outlets
    @IBOutlet var tenantName: UILabel!
    @IBOutlet var logourl: UIImageView!
    @IBOutlet var email: CustomTextField!
    @IBOutlet var givenName: CustomTextField!
    @IBOutlet var familyName: CustomTextField!
    @IBOutlet var password: CustomTextField!
    @IBOutlet var confirmPassword: CustomTextField!
    
    // local variables
    var cidaas = Cidaas.shared
    var requestId: String = ""
    var tenant_name: String = ""
    var logo_uri: UIImage = UIImage(named: "app-logo")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign values
        self.tenantName.text = self.tenant_name
        self.logourl.image = self.logo_uri
        
        self.getRegistrationFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLogo(logo_uri: String) {
        // set logo url
        if (logo_uri != "") {
            self.logourl.sd_setImage(with: URL(string: logo_uri), completed: { (image, error, type, url) in
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
    }
    
    func getRegistrationFields() {
        
        // show loader
        showLoader()
        
        // call getRegistrationFields API
        cidaas.getRegistrationFields(requestId: self.requestId) {
            switch $0 {
            case .failure(let error):
                
                // hide loader
                self.hideLoader()
                self.showAlert(message: error.errorMessage, style: .info)
                
            case .success(let response):
                print("COUNT : \(response.data.count)")
                
                // hide loader
                self.hideLoader()
            }
        }
    }
    
    // register submit
    @IBAction func register(_ sender: Any) {
        
        // construct object
        let registrationEntity = RegistrationEntity()
        registrationEntity.email = self.email.text ?? ""
        registrationEntity.given_name = self.givenName.text ?? ""
        registrationEntity.family_name = self.familyName.text ?? ""
        registrationEntity.password = self.password.text ?? ""
        registrationEntity.password_echo = self.confirmPassword.text ?? ""
        registrationEntity.provider = "self"
        
        // show loader
        showLoader()
        
        // call register user API
        cidaas.registerUser(requestId: self.requestId, registrationEntity: registrationEntity) {
            switch $0 {
            case .failure(let error):
                
                // hide loader
                self.hideLoader()
                self.showAlert(message: error.errorMessage, style: .info)
                
            case .success(let response):
                print("SUGGESTED ACTION : \(response.data.suggested_action)")
                print("TrackId : \(response.data.trackId)")
                
                // hide loader
                self.hideLoader()
                
                if (response.data.suggested_action == "DEDUPLICATION") {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeduplicationViewController") as! DeduplicationViewController
                    vc.track_id = response.data.trackId
                    self.navigationController?.pushViewController(vc, animated: true)
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
}
