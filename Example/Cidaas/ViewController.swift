//
//  ViewController.swift
//  Cidaas
//
//  Created by Cidaas on 08/23/2018.
//  Copyright (c) 2018 Cidaas. All rights reserved.
//

import UIKit
import Cidaas
import AuthenticationServices

class ViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
   // var cidaas = Cidaas.shared
    var cidaasNative = CidaasNative.shared
    var cidaas = Cidaas.shared
  //  var cidaasConsent = CidaasConsent()
     var requestID: String = ""
    var accessToken : String = ""
    var sub: String = ""
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logoutBtn(_ sender: Any) {
        self.readdata();
        print(accessToken)
        cidaasNative.logout(access_token: accessToken){
           switch $0 {
               case .success(let loginSuccess):
                   print( loginSuccess);
                  
               break
               case .failure(let error):
                   print(error);
               break
           }
        }
    }
    @IBAction func updateUser(_ sender: Any) {
        self.readdata()
       let incomingData = RegistrationEntity()
           incomingData.given_name = "Test"
           incomingData.sub = sub
        incomingData.provider = "self"
            print(incomingData.sub)
        print("Access Token : "+accessToken)
       
           self.cidaasNative.updateUser(access_token: accessToken, incomingData: incomingData) {
               switch $0 {
                   case .success(let updateResponse):
                       print(updateResponse.data.updated)
                       self.getUserInfo()
                       break
                   case .failure(let errorResponse):
                       print(errorResponse.errorMessage)
                       break
               }
           }
       
    }
    
    func getUserInfo() {
        self.cidaas.getUserInfo(sub: sub) {
            switch $0 {
                case .success(let profileResponse):
                    print(profileResponse.email)
                    break
                case .failure(let errorResponse):
                    print(errorResponse.errorMessage)
                    break
            }
        }
    }
        
    @IBAction func login(_ sender: Any) {
//        cidaas.loginWithBrowser(delegate: self) {
//            switch $0 {
//                case .success(let successResponse):
//                    // your success code here
//                    print("Access Token - \(successResponse.data.access_token)")
//                    break
//                case .failure(let error):
//                    // your failure code here
//                    print("Error - \(error.errorMessage)")
//                    break
//            }
//        }
        
    
        cidaasNative.getRequestId(){
                   switch $0 {
                       case .success(let loginSuccess):
                           print( loginSuccess);
                           self.requestID = loginSuccess.data.requestId
                           self.login()
                       break
                       case .failure(let error):
                           print(error);
                       break
                   }
               }
      //  login();
        
         
    }
    
    func login(){
        let loginEntity = LoginEntity()
                loginEntity.username = ""
                loginEntity.password = ""
                loginEntity.username_type = "email" // either email or mobile or username
                loginEntity.requestId = self.requestID
        
               cidaasNative.loginWithCredentials(incomingData: loginEntity) {
                   switch $0 {
                       case .success(let loginSuccess):

                           print( loginSuccess);
                           self.saveaccessToken(accesstoken: loginSuccess.data.access_token);
                           self.sub = loginSuccess.data.sub
                           
                           
                       break
                       case .failure(let error):
                           print(error);
                       break
                   }
               }
    }
    func saveaccessToken(accesstoken :  String) -> Void{
        let preferences = UserDefaults.standard

        let currentLevel = accesstoken
        let currentLevelKey = "currentLevel"
        preferences.set(currentLevel, forKey: currentLevelKey)
    }
    func readdata() -> Void {
        let preferences = UserDefaults.standard

        let currentLevelKey = "currentLevel"
        if preferences.object(forKey: currentLevelKey) == nil {
            //  Doesn't exist
        } else {
            let currentLevel = preferences.string(forKey: currentLevelKey);
            print(currentLevel as Any);
            accessToken = currentLevel ?? "0";
        }
    }
    
    
    
    
    @available(iOS 12.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
}
