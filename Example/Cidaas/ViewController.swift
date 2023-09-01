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
        self.getRequestId()
    }
    
    func getRequestId() {
        cidaasNative.getRequestId {
            switch $0 {
                case .success(let successResponse):
                    // your success code here
                    self.requestID = successResponse.data.requestId
                    break
                case .failure(let error):
                    // your failure code here
                    print("Error - \(error.errorMessage)")
                    break
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let registrationEntity = RegistrationEntity()
        registrationEntity.email = "xxx@gmail.com"
        registrationEntity.given_name = "xx"
        registrationEntity.family_name = "xx"
        registrationEntity.password = "123456"
        registrationEntity.password_echo = "123456"
        registrationEntity.provider = "SELF"
        
        registrationEntity.customFields = Dictionary<String, RegistrationCustomFieldsEntity>()
        
        // add customField
        
        let field: RegistrationCustomFieldsEntity = RegistrationCustomFieldsEntity()
        field.value = true
        field.key = "field_key"
        
        registrationEntity.customFields["field"] = field
        
        cidaasNative.registerUser(requestId: self.requestID, incomingData: registrationEntity) {
            switch $0 {
                case .success(let successResponse):
                    // your success code here
                    print("User Status - \(successResponse.data.userStatus)")
                   break
                case .failure(let error):
                    // your failure code here
                    print("Error - \(error.errorMessage)")
                    break
            }
        }
    }
        
    @IBAction func login(_ sender: Any) {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("I am here")
            print("\(key) = \(value) \n")
        }

            cidaas.loginWithBrowser(delegate: self) {

                switch $0 {

                    case .success(let successResponse):

                        // your success code here

                        print("Access Token - \(successResponse.data.access_token)")

    //                    self.logout(accessToken: successResponse.data.access_token)

                        self.getUserInfo(accessToken: successResponse.data.access_token)

                        break

                    case .failure(let error):

                        // your failure code here

                        print("Error - \(error.errorMessage)")

                        break

                }

            }

        }
    
    func getUserInfo(accessToken: String) {
        AccessTokenController.shared.getAccessToken(sub: "f1a8e35f-d604-4f97-b964-96a3dbd863d7") {
            switch $0 {
                case .success(let successResponse):
                print("Here I got my dataaaaaaaa")
                print(successResponse)
                    break
                case .failure( _):
                    break
            }
        }
      //  for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
        //      print("Here I got my data")
        //       print("\(key) = \(value) \n")
        //   }
        cidaas.getUserInfo(accessToken: accessToken) {
            switch $0 {
                case .success(let userInfo):
                    print(userInfo.customFields)
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
    
    
    func logout(accessToken: String) {

            cidaasNative.logout(access_token: accessToken) {

                switch $0 {

                case .success(_):

                    break

                    case .failure(let error):

                        print(error);

                    break

                }

            }

        }
    
    
    @available(iOS 12.0, *)
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
}
