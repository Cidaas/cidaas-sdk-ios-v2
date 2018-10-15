//
//  IVRVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class IVRVerificationController {
    
    // local variables
    private var authenticationType: String
    public var sub: String
    private var trackId: String
    private var requestId: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : IVRVerificationController = IVRVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.requestId = ""
        self.trackId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
    }
    
    // configure IVR from properties
    public func configureIVR(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<SetupIVRResponseEntity>) -> Void) {
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
            error.error = "sub must not be empty"
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
                
                // call configureIVR service
                IVRVerificationService.shared.setupIVR(access_token: tokenResponse.data.access_token, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure IVR service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure IVR service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
    
    // configrue IVR from properties
    public func configureIVR(statusId: String, code: String, properties: Dictionary<String, String>, callback: @escaping(Result<VerifyIVRResponseEntity>) -> Void) {
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
            error.error = "statusId or code must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
            
            // validating fields
            if (self.sub == "") {
                let error = WebAuthError.shared.propertyMissingException()
                error.error = "sub must not be empty"
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
                    let enrollIVREntity = EnrollIVREntity()
                    enrollIVREntity.code = code
                    enrollIVREntity.statusId = statusId
                    
                    // call setup service
                    IVRVerificationService.shared.enrollIVR(access_token: tokenResponse.data.access_token, enrollIVREntity: enrollIVREntity, properties: properties) {
                        switch $0 {
                        case .failure(let error):
                            // log error
                            let loggerMessage = "Enroll IVR service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success(let serviceResponse):
                            // log success
                            let loggerMessage = "Configure IVR service success : " + "Tracking Code  - " + String(describing: serviceResponse.data.trackingCode) + ", Sub  - " + String(describing: serviceResponse.data.sub)
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
    
    // login with IVR from properties
    public func loginWithIVR(email : String, mobile: String, sub: String, trackId: String, requestId: String, usageType: String, properties: Dictionary<String, String>, callback: @escaping(Result<InitiateIVRResponseEntity>) -> Void) {
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
            error.error = "email or sub or mobile or requestId must not be empty"
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
        self.requestId = requestId
        
        // construct object
        let initiateIVREntity = InitiateIVREntity()
        initiateIVREntity.email = email
        initiateIVREntity.mobile = mobile
        initiateIVREntity.sub = sub
        initiateIVREntity.usageType = usageType
        
        // call initiateIVR service
        IVRVerificationService.shared.initiateIVR(initiateIVREntity: initiateIVREntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate IVR service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate IVR service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                self.authenticationType = AuthenticationTypes.LOGIN.rawValue
                self.sub = sub
                self.trackId = trackId
                
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
    
    // verify IVR from properties
    public func verifyIVR(statusId: String, code: String, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
            error.error = "statusId or code or requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
            // construct object
            let authenticateIVREntity = AuthenticateIVREntity()
            authenticateIVREntity.code = code
            authenticateIVREntity.statusId = statusId
            
            // call setup service
            IVRVerificationService.shared.authenticateIVR(authenticateIVREntity: authenticateIVREntity, properties: properties) {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Authenticate IVR service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let serviceResponse):
                    // log success
                    let loggerMessage = "Authenticate IVR service success : " + "Tracking Code  - " + String(describing: serviceResponse.data.trackingCode) + ", Sub  - " + String(describing: serviceResponse.data.sub)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    let mfaContinueEntity = MFAContinueEntity()
                    mfaContinueEntity.requestId = self.requestId
                    mfaContinueEntity.sub = serviceResponse.data.sub
                    mfaContinueEntity.trackId = self.trackId
                    mfaContinueEntity.trackingCode = serviceResponse.data.trackingCode
                    mfaContinueEntity.verificationType = "IVR"
                    
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
