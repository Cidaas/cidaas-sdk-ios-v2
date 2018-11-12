//
//  ChangepasswordController.swift
//  Cidaas
//
//  Created by ganesh on 01/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ChangepasswordController {
    
    // shared instance
    public static var shared : ChangepasswordController = ChangepasswordController()
    
    // constructor
    public init() {
        
    }
    
    // change password
    public func changePassword(sub: String, changePasswordEntity: ChangePasswordEntity, properties: Dictionary<String, String>, callback: @escaping(Result<ChangePasswordResponseEntity>) -> Void) {
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
        if (sub == "" || changePasswordEntity.old_password == "" || changePasswordEntity.new_password == "" || changePasswordEntity.confirm_password == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub or old_password or new_password or confirm_password must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        if (changePasswordEntity.new_password != changePasswordEntity.confirm_password) {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "new_password and confirm_password must be same"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // get access token from sub
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Access token failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tokenResponse):
                // log success
                let loggerMessage = "Access Token success : " + "Access Token  - " + String(describing: tokenResponse.data.access_token)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // getting user info to get the identity id
                UsersService.shared.getUserInfo(accessToken: tokenResponse.data.access_token, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Get UserInfo Details service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tenantInfoResponse):
                        // log success
                        let loggerMessage = "Get UserInfo Details service success : " + "Email  - " + String(describing: tenantInfoResponse.email) + "Identity Id  - " + String(describing: tenantInfoResponse.last_used_identity_id)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // call change password service
                        ChangePasswordService.shared.changePassword(access_token: tokenResponse.data.access_token, identityId: tenantInfoResponse.last_used_identity_id, changePasswordEntity: changePasswordEntity, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // log error
                                let loggerMessage = "Change password service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                // return failure callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let tenantInfoResponse):
                                // log success
                                let loggerMessage = "Change password service success : " + "Changed Status  - " + String(describing: tenantInfoResponse.data.changed)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: tenantInfoResponse))
                                }
                            }
                        }
                        
                        
                    }
                }
                
            }
        }
    }
}
