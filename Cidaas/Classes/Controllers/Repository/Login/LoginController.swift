//
//  LoginController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class LoginController {
    
    // shared instance
    public static var shared : LoginController = LoginController()
    
    // constructor
    public init() {
        
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
            error.error = "requestId or loginEntity.username or loginEntity.password must not be empty"
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
