//
//  UsersController.swift
//  Cidaas
//
//  Created by ganesh on 31/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class UsersController {
    
    // shared instance
    public static var shared : UsersController = UsersController()
    
    // constructor
    public init() {
        
    }
    
    // get user info
    public func getUserInfo(access_token: String, properties: Dictionary<String, String>, callback: @escaping(Result<UserInfoEntity>) -> Void) {
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
        
        
        
        // call get user info service
        UsersService.shared.getUserInfo(accessToken: access_token, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "User-Info service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tenantInfoResponse):
                // log success
                let loggerMessage = "User-Info service success : " + "Email  - " + String(describing: tenantInfoResponse.email)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: tenantInfoResponse))
                }
            }
        }
    }
}
