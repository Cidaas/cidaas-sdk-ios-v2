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
    var cidaas = CidaasNative()
     var requestID: String = ""
    var accessToken : String = ""
    
    // did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logoutBtnClicked(_ sender: Any) {
        self.readdata();
        print(accessToken)
        cidaas.logout(access_token: accessToken){
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
        cidaas.getRequestId(){
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
                loginEntity.username = "ganesh.kumar@widas.in"
                loginEntity.password = ""
                loginEntity.username_type = "email" // either email or mobile or username
                loginEntity.requestId = self.requestID
        
        

               cidaas.loginWithCredentials(incomingData: loginEntity) {
                   switch $0 {
                       case .success(let loginSuccess):
                           print( loginSuccess);
                            self.saveaccessToken(accesstoken: loginSuccess.data.access_token);
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
