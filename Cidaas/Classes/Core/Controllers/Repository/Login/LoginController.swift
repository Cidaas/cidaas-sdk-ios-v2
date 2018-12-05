//
//  LoginController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import SafariServices

public class LoginController {
    
    // shared instance
    public static var shared : LoginController = LoginController()
    public var delegate: UIViewController = UIViewController()
    public var storage: TransactionStore = TransactionStore.shared
    
    // constructor
    public init() {
        
    }
    
    // login With browser
    public func loginWithBrowser(delegate: UIViewController, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil || properties["RedirectURL"] == "" || properties["RedirectURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        self.delegate = delegate
        
        // construct url
        let loginURL = constructURL(properties: properties)
        let redirectURL = URL(string: properties["RedirectURL"] ?? "")!
        
        if #available(iOS 11.0, *) {
            
            // initiate safari session with the constructed url performing single sign on
            let session = SafariAuthenticationSession(loginURL: loginURL, redirectURL: redirectURL, callback: callback)
            
            // save the session
            self.storage.store(session)
        }
        else {
            
            // call open safari method
            openSafari(loginURL : loginURL)
        }
        
        
    }
    
    // open safari browser. This method opens the Safari browser to display the login page. This method should be called internally and only for lower versions of ios (below 11.0)
    private func openSafari(loginURL : URL) {
        
        // assign url to safari controller
        let vc = SFSafariViewController(url: loginURL)
        
        // present the safari controller
        self.delegate.present(vc, animated: true, completion: nil)
    }
    
    private func constructURL(properties: Dictionary<String, String>) -> URL {
        
        var urlParams = Dictionary<String, String>()
        urlParams["redirect_uri"] = properties["RedirectURL"] ?? ""
        urlParams["response_type"] = "code"
        urlParams["client_id"] = properties["ClientId"] ?? ""
        urlParams["view_type"] = properties["ViewType"] ?? "login"
        urlParams["code_challenge"] = properties["Challenge"]
        urlParams["code_challenge_method"] = properties["Method"]
        
        var urlComponents = URLComponents(string : properties["AuthorizationURL"] ?? "")
        urlComponents?.queryItems = []
        for (key, value) in urlParams {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return (urlComponents?.url)!
    }
    
    // login With Credentials
    public func loginWithCredentials(requestId: String, loginEntity: LoginEntity, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (requestId == "" || loginEntity.username == "" || loginEntity.password == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "requestId or loginEntity.username or loginEntity.password must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // setting default username_type
        if (loginEntity.username_type == "") {
            loginEntity.username_type = "email"
        }
        
        // call loginWithCredentials service
        LoginService.shared.loginWithCredentials(requestId: requestId, loginEntity: loginEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Login With Credentials service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let authzCodeResponse):
                // log success
                let loggerMessage = "Login With Credentials service success : " + "Authz Code  - " + String(describing: authzCodeResponse.data.code)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                AccessTokenController.shared.getAccessToken(code: authzCodeResponse.data.code) {
                    switch $0 {
                    case .failure(let error):
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tokenResponse):
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: tokenResponse))
                        }
                        return
                    }
                }
            }
        }
    }
}
