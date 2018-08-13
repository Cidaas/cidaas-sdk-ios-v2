//
//  AccountVerificationController.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AccountVerificationController {
    
    // shared instance
    public static var shared : AccountVerificationController = AccountVerificationController()
    
    // constructor
    public init() {
        
    }
    
    // initiate account verification
    public func initiateAccountVerification(requestId: String, sub: String, verificationMedium: String, properties: Dictionary<String, String>, callback: @escaping(Result<InitiateAccountVerificationResponseEntity>) -> Void) {
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
        if (requestId == "" || sub == "" || verificationMedium == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "requestId or sub or verificationMedium must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let initiateAccountVerificationEntity = InitiateAccountVerificationEntity()
        initiateAccountVerificationEntity.requestId = requestId
        initiateAccountVerificationEntity.sub = sub
        initiateAccountVerificationEntity.verificationMedium = verificationMedium
        initiateAccountVerificationEntity.processingType = "CODE"
        
        // call initiateAccountVerification service
        AccountVerificationService.shared.initiateAccountVerification(accountVerificationEntity: initiateAccountVerificationEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate account verification service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate account verification service success : " + "Account Verification Id - " + serviceResponse.data.accvid
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
    
    // verify account
    public func verifyAccount(accvid: String, code: String, properties: Dictionary<String, String>, callback: @escaping(Result<VerifyAccountResponseEntity>) -> Void) {
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
        if (code == "" || accvid == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "code or accvid must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let accountVerificationEntity = VerifyAccountEntity()
        accountVerificationEntity.code = code
        accountVerificationEntity.accvid = accvid
        
        // call verifyAccount service
        AccountVerificationService.shared.verifyAccount(accountVerificationEntity: accountVerificationEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Verify account service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Verify account service success : " + "Success - " + String(describing: serviceResponse.success)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
}
