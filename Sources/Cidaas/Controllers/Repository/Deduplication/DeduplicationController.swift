//
//  DeduplicationController.swift
//  Cidaas
//
//  Created by ganesh on 31/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class DeduplicationController {
    
    // shared instance
    public static var shared : DeduplicationController = DeduplicationController()
    
    // constructor
    public init() {
        
    }
    
    // get deduplication details
    public func getDeduplicationDetails(track_id: String, properties: Dictionary<String, String>, callback: @escaping(Result<DeduplicationDetailsResponseEntity>) -> Void) {
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
        if (track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "track_id must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call get deduplication details service
        DeduplicationService.shared.getDeduplicationDetails(track_id: track_id, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get Deduplication Details service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tenantInfoResponse):
                // log success
                let loggerMessage = "Get Deduplication Details service success : " + "Email  - " + String(describing: tenantInfoResponse.data.email)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: tenantInfoResponse))
                }
            }
        }
    }
    
    // register deduplication
    public func registerDeduplication(track_id: String, properties: Dictionary<String, String>, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
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
        if (track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "track_id must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        
        // call registerDeduplication service
        DeduplicationService.shared.registerDeduplication(track_id: track_id, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Register Deduplication service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tenantInfoResponse):
                // log success
                let loggerMessage = "Register Deduplication service success : " + "Sub  - " + String(describing: tenantInfoResponse.data.sub)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: tenantInfoResponse))
                }
            }
        }
    }
    
    // login deduplication
    public func deduplicationLogin(requestId: String, sub: String, password: String, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        if (requestId == "" || sub == "" || password == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "requestId or sub or password must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let loginEntity = LoginEntity()
        loginEntity.username = sub
        loginEntity.password = password
        loginEntity.username_type = "sub"
        
        // call registerDeduplication service
        DeduplicationService.shared.deduplicationLogin(requestId: requestId, loginEntity: loginEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Login Deduplication service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let authzCodeResponse):
                // log success
                let loggerMessage = "Login Deduplication service success : " + "Code  - " + String(describing: authzCodeResponse.data.code)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // get accesstoken from code
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
