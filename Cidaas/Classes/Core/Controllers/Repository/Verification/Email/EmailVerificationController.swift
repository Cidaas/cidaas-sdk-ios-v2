//
//  EmailVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class EmailVerificationController {
    
    // local variables
    private var authenticationType: String
    public var sub: String
    private var trackId: String
    private var requestId: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : EmailVerificationController = EmailVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.trackId = ""
        self.requestId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
    }
    
    // configure email from properties
    public func configureEmail(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<SetupEmailResponseEntity>) -> Void) {
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
        if (sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub must not be empty"
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
                
                // call configureEmail service
                EmailVerificationService.shared.setupEmail(access_token: tokenResponse.data.access_token, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure Email service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure Email service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
                        self.sub = sub
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: serviceResponse))
                        }
                    }
                }
            }
        }
    }
    
    // verify email from properties
    public func configureEmail(statusId: String, code: String, properties: Dictionary<String, String>, callback: @escaping(Result<VerifyEmailResponseEntity>) -> Void) {
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
        if (statusId == "" || code == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or code must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        
        // validating fields
        if (self.sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub must not be empty"
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
                
                
                // construct object
                let enrollEmailEntity = EnrollEmailEntity()
                enrollEmailEntity.code = code
                enrollEmailEntity.statusId = statusId
                
                // call setup service
                EmailVerificationService.shared.enrollEmail(access_token: tokenResponse.data.access_token, enrollEmailEntity: enrollEmailEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Enroll Email service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure Email service success : " + "Tracking Code  - " + String(describing: serviceResponse.data.trackingCode) + ", Sub  - " + String(describing: serviceResponse.data.sub)
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
    
    // login with email from properties
    public func loginWithEmail(email : String, mobile: String, sub: String, trackId: String, requestId: String, usageType: String, properties: Dictionary<String, String>, callback: @escaping(Result<InitiateEmailResponseEntity>) -> Void) {
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
        if ((email == "" && sub == "" && mobile == "") || requestId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "email or sub or mobile or requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        if (usageType == UsageTypes.MFA.rawValue) {
            if (trackId == "") {
                let error = WebAuthError.shared.propertyMissingException()
                error.errorMessage = "trackId must not be empty"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        else {
            if (usageType != UsageTypes.PASSWORDLESS.rawValue) {
                let error = WebAuthError.shared.propertyMissingException()
                error.errorMessage = "Invalid usageType. usageType should be either PASSWORDLESS_AUTHENTICATION or MULTIFACTOR_AUTHENTICATION"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        
        self.usageType = usageType
        
        // construct object
        let initiateEmailEntity = InitiateEmailEntity()
        initiateEmailEntity.email = email
        initiateEmailEntity.sub = sub
        initiateEmailEntity.mobile = mobile
        initiateEmailEntity.usageType = usageType
        
        // call initiateEmail service
        EmailVerificationService.shared.initiateEmail(initiateEmailEntity: initiateEmailEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate Email service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate Email service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                self.authenticationType = AuthenticationTypes.LOGIN.rawValue
                self.sub = sub
                self.requestId = requestId
                self.trackId = trackId
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
    
    // verify email from properties
    public func verifyEmail(statusId: String, code: String, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        if (statusId == "" || code == "" || self.requestId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or code or requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let authenticateEmailEntity = AuthenticateEmailEntity()
        authenticateEmailEntity.code = code
        authenticateEmailEntity.statusId = statusId
        
        // call setup service
        EmailVerificationService.shared.authenticateEmail(authenticateEmailEntity: authenticateEmailEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Authenticate Email service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Authenticate Email service success : " + "Tracking Code  - " + String(describing: serviceResponse.data.trackingCode) + ", Sub  - " + String(describing: serviceResponse.data.sub)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                let mfaContinueEntity = MFAContinueEntity()
                mfaContinueEntity.requestId = self.requestId
                mfaContinueEntity.sub = serviceResponse.data.sub
                mfaContinueEntity.trackId = self.trackId
                mfaContinueEntity.trackingCode = serviceResponse.data.trackingCode
                mfaContinueEntity.verificationType = "EMAIL"
                
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
