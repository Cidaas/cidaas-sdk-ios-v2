//
//  FacebookController.swift
//  Cidaas
//
//  Created by ganesh on 15/10/18.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKCoreKit

public class FacebookController {
    
    // shared Instance
    public static var shared : FacebookController = FacebookController()
    
    // local variables
    var loginManager: LoginManager
    public var delegate: UIViewController!
    
    public init() {
        loginManager = LoginManager()
    }
    
    public func login(properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
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
        
        loginManager.logIn(readPermissions: [.email, .publicProfile], viewController: delegate) { (loginResult) in
            switch loginResult {
                case .cancelled:
                    let error = WebAuthError.shared
                    error.errorMessage = "You have Cancelled the request"
                    error.error = ""
                    error.statusCode = HttpStatusCode.CANCEL_REQUEST.rawValue
                    
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    break
                case .failed(let loginError):
                    
                    let error = WebAuthError.shared
                    error.errorMessage = loginError.localizedDescription
                    error.error = loginError
                    error.statusCode = HttpStatusCode.INTERNAL_SERVER_ERROR.rawValue
                    
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    break
                case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                    let token = AccessToken.current?.authenticationToken
                    if token != nil {
                        
                    }
                    else {
                        let error = WebAuthError.shared
                        error.errorMessage = "Token from Facebook is Empty"
                        error.error = "Token from Facebook is Empty"
                        error.statusCode = HttpStatusCode.INTERNAL_SERVER_ERROR.rawValue
                        
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                    }
                    break
            }
        }
    }
    
    public func logout() {
        loginManager.logOut()
    }
}
