//
//  ConsentManagementViewController.swift
//  SDKCheck
//
//  Created by ganesh on 16/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas

class ConsentManagementViewController: UIViewController {

    // outlets
    
    @IBOutlet var serviceName: UILabel!
    @IBOutlet var consentDescription: UILabel!
    @IBOutlet var userAgreeText: UILabel!
    @IBOutlet var contactInfo: UILabel!
    @IBOutlet var checkbox: Checkbox!
    
    // local variables
    var cidaas = Cidaas.shared
    var consent_name: String = ""
    var sub: String = ""
    var track_id: String = ""
    var version: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkbox.checkedBorderColor = UIColor(hexColor: 0xFD9226)
        checkbox.uncheckedBorderColor = UIColor(hexColor: 0xFD9226)
        checkbox.borderStyle = .square
        checkbox.checkmarkColor = UIColor(hexColor: 0xFD9226)
        checkbox.checkmarkStyle = .tick
        
        getConsentDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // get consent details
    func getConsentDetails() {
        
        // show loader
        showLoader()
        
        // call get consent details API
        cidaas.getConsentDetails(consent_name: self.consent_name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) {
            switch($0) {
            case .failure(let error):
                print("ERROR: \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
            case .success(let response):
                print("CONSENT NAME : \(response.data.name)")
                print("DESCRIPTION : \(response.data.description)")
                print("USER AGREE TEXT : \(response.data.userAgreeText)")
                
                // set service name, description, user agree text and contact information
                self.serviceName.text = "Service : \(response.data.services[0].service)"
                self.consentDescription.text = response.data.description
                self.userAgreeText.text = response.data.userAgreeText
                self.contactInfo.text = "Name : \(response.data.piiControllers[0].contact)\n\nEmail : \(response.data.piiControllers[0].email)"
                self.version = response.data.version
                
                // hide loader
                self.hideLoader()
            }
        }
    }
    
    // accept consent
    @IBAction func acceptConsent(_ sender: Any) {
        
        // construnct an object
        let consentEntity = ConsentEntity()
        consentEntity.consent_name = consent_name
        consentEntity.sub = sub
        consentEntity.track_id = track_id
        consentEntity.version = version
        consentEntity.accepted = true
        
        // show loader
        showLoader()
        
        // call login after consent API
        cidaas.loginAfterConsent(consentEntity: consentEntity) {
            switch($0) {
            case .failure(let error):
                print("ERROR: \(error.errorMessage)")
                
                // hide loader
                self.hideLoader()
                
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
    
    func showLoader() {
        CustomLoader.sharedCustomLoaderInstance.showLoader(self.view, using: nil) { _ in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.sharedCustomLoaderInstance.hideLoader(self.view)
    }
}

public extension UIColor {
    
    // init with rgb
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // init with hex color
    public convenience init(hexColor:Int) {
        self.init(red:(hexColor >> 16) & 0xff, green:(hexColor >> 8) & 0xff, blue:hexColor & 0xff)
    }
}
