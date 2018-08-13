//
//  BackupcodeVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class BackupcodeVerificationController {
    
    // local variables
    private var statusId: String
    private var authenticationType: String
    private var sub: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : BackupcodeVerificationController = BackupcodeVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
    }
    
    // configure Backupcode from properties
    public func configureBackupcode(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<SetupBackupcodeResponseEntity>) -> Void) {
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
                
                // call configureBackupcode service
                BackupcodeVerificationService.shared.setupBackupcode(access_token: tokenResponse.data.access_token, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure Backupcode service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure Backupcode service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: serviceResponse))
                        }
                    }
                }
            }
        }
    }
    
    // login with Backupcode from properties
    public func loginWithBackupcode(email : String, mobile: String, sub: String, code: String, trackId: String, requestId: String, usageType: String, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        if ((email == "" && sub == "" && mobile == "") || requestId == "" || code == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "email or sub or mobile or requestId or code must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        if (usageType == UsageTypes.MFA.rawValue) {
            if (trackId == "") {
                let error = WebAuthError.shared.propertyMissingException()
                error.error = "trackId must not be empty"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        else {
            if (usageType != UsageTypes.PASSWORDLESS.rawValue) {
                let error = WebAuthError.shared.propertyMissingException()
                error.error = "Invalid usageType. usageType should be either PASSWORDLESS_AUTHENTICATION or MULTIFACTOR_AUTHENTICATION"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        
        self.usageType = usageType
        
        // construct object
        let initiateBackupcodeEntity = InitiateBackupcodeEntity()
        initiateBackupcodeEntity.email = email
        initiateBackupcodeEntity.sub = sub
        initiateBackupcodeEntity.usageType = usageType
        
        // call initiateBackupcode service
        BackupcodeVerificationService.shared.initiateBackupcode(initiateBackupcodeEntity: initiateBackupcodeEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate Backupcode service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate Backupcode service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                self.statusId = serviceResponse.data.statusId
                self.authenticationType = AuthenticationTypes.LOGIN.rawValue
                self.sub = sub
                
                // construct object
                let authenticateBackupcodeEntity = AuthenticateBackupcodeEntity()
                authenticateBackupcodeEntity.code = code
                authenticateBackupcodeEntity.statusId = self.statusId
                
                // call authenticateBackupcode service
                BackupcodeVerificationService.shared.authenticateBackupcode(authenticateBackupcodeEntity: authenticateBackupcodeEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Authenticate Backupcode service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Authenticate Backupcode service success : " + "Tracking code  - " + String(describing: serviceResponse.data.trackingCode) + ", Sub  - " + String(describing: serviceResponse.data.sub)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        let mfaContinueEntity = MFAContinueEntity()
                        mfaContinueEntity.requestId = requestId
                        mfaContinueEntity.sub = serviceResponse.data.sub
                        mfaContinueEntity.trackId = trackId
                        mfaContinueEntity.trackingCode = serviceResponse.data.trackingCode
                        mfaContinueEntity.verificationType = "BACKUPCODE"
                        
                        if(self.usageType == UsageTypes.PASSWORDLESS.rawValue) {
                            VerificationSettingsService.shared.passwordlessContinue(mfaContinueEntity: mfaContinueEntity, properties: properties) {
                                switch $0 {
                                case .failure(let error):
                                    // log error
                                    let loggerMessage = "MFA Continue service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                    
                                    // return failure callback
                                    DispatchQueue.main.async {
                                        callback(Result.failure(error: error))
                                    }
                                    return
                                case .success(let serviceResponse):
                                    // log success
                                    let loggerMessage = "MFA Continue service success : " + "Authz Code  - " + String(describing: serviceResponse.data.code) + ", Grant Type  - " + String(describing: serviceResponse.data.grant_type)
                                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                    
                                    AccessTokenController.shared.getAccessToken(code: serviceResponse.data.code, callback: callback)
                                    
                                }
                            }
                        }
                        else {
                            
                            VerificationSettingsService.shared.mfaContinue(mfaContinueEntity: mfaContinueEntity, properties: properties) {
                                switch $0 {
                                case .failure(let error):
                                    // log error
                                    let loggerMessage = "MFA Continue service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                    
                                    // return failure callback
                                    DispatchQueue.main.async {
                                        callback(Result.failure(error: error))
                                    }
                                    return
                                case .success(let serviceResponse):
                                    // log success
                                    let loggerMessage = "MFA Continue service success : " + "Authz Code  - " + String(describing: serviceResponse.data.code) + ", Grant Type  - " + String(describing: serviceResponse.data.grant_type)
                                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                    
                                    AccessTokenController.shared.getAccessToken(code: serviceResponse.data.code, callback: callback)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
