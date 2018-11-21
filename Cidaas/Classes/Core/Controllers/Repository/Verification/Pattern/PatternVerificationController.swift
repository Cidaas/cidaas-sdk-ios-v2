//
//  PatternVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class PatternVerificationController {
    
    // local variables
    private var statusId: String
    private var authenticationType: String
    private var sub: String
    private var verificationType: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : PatternVerificationController = PatternVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.verificationType = ""
    }
    
    // configure PatternRecognition from properties
    public func configurePatternRecognition(pattern: String, sub: String, logoUrl: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollPatternResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil {
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
        if (pattern == "" || sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub or pattern must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.PATTERN.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
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
                var setupPatternEntity = SetupPatternEntity()
                setupPatternEntity.logoUrl = logoUrl
                
                // call setupPattern service
                PatternVerificationService.shared.setupPattern(accessToken: tokenResponse.data.access_token, setupPatternEntity: setupPatternEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure Pattern service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure Pattern service success : " + "Status Id  - " + String(describing: serviceResponse.data.st)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        var timer: Timer = Timer()
                        var timerCount: Int16 = 0
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer_response) in
                            if (timerCount > 10) {
                                timerCount = 0
                                timer.invalidate()
                                
                                let error = WebAuthError.shared.notificationTimeoutException()
                                
                                // log error
                                let loggerMessage = "Device Verification failure. Notification timeout : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            }
                            if (Cidaas.intermediate_verifiation_id != "") {
                                timerCount = 0
                                timer.invalidate()
                                
                                // construct object
                                setupPatternEntity = SetupPatternEntity()
                                setupPatternEntity.usage_pass = Cidaas.intermediate_verifiation_id
                                
                                // call validate device
                                PatternVerificationService.shared.setupPattern(accessToken: tokenResponse.data.access_token, setupPatternEntity: setupPatternEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let validateDeviceResponse):
                                        // log success
                                        let loggerMessage = "Setup Pattern with usage pass service success : " + "User device Id - " + String(describing: validateDeviceResponse.data.udi)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        // save user device id based on tenant
                                        DBHelper.shared.setUserDeviceId(userDeviceId: validateDeviceResponse.data.udi, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                        
                                        self.statusId = validateDeviceResponse.data.st
                                        
                                        // construct method
                                        let enrollPatternEntity = EnrollPatternEntity()
                                        enrollPatternEntity.statusId = self.statusId
                                        enrollPatternEntity.userDeviceId = validateDeviceResponse.data.udi
                                        enrollPatternEntity.verifierPassword = pattern
                                        
                                        // call enroll service
                                        PatternVerificationController.shared.enrollPatternRecognition(access_token: tokenResponse.data.access_token, enrollPatternEntity: enrollPatternEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let enrollResponse):
                                                // return success callback
                                                DispatchQueue.main.async {
                                                    callback(Result.success(result: enrollResponse))
                                                }
                                            }
                                        }
                                        
                                        break
                                    case .failure(let error):
                                        // return callback
                                        DispatchQueue.main.async {
                                            callback(Result.failure(error: error))
                                        }
                                        break
                                    }
                                }
                            }
                            else {
                                timerCount = timerCount + 1
                            }
                        })
                    }
                }
            }
        }
    }
    
    // Web to Mobile
    // scanned PatternRecognition from properties
    public func scannedPatternRecognition(statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<ScannedPatternResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil {
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
        if (statusId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.PATTERN.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // construct object
        var scannedPatternEntity = ScannedPatternEntity()
        scannedPatternEntity.statusId = statusId
        
        // call setupPattern service
        PatternVerificationService.shared.scannedPattern(scannedPatternEntity: scannedPatternEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Scanned Pattern service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Scanned Pattern service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                var timer: Timer = Timer()
                var timerCount: Int16 = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer_response) in
                    if (timerCount > 10) {
                        timerCount = 0
                        timer.invalidate()
                        
                        let error = WebAuthError.shared.notificationTimeoutException()
                        
                        // log error
                        let loggerMessage = "Device Verification failure. Notification timeout : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    }
                    if (Cidaas.intermediate_verifiation_id != "") {
                        timerCount = 0
                        timer.invalidate()
                        
                        // construct object
                        scannedPatternEntity = ScannedPatternEntity()
                        scannedPatternEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call validate device
                        PatternVerificationService.shared.scannedPattern(scannedPatternEntity: scannedPatternEntity, properties: properties) {
                            switch $0 {
                            case .success(let validateDeviceResponse):
                                // log success
                                let loggerMessage = "Scanned Pattern with usage pass service success : " + "User device Id - " + String(describing: validateDeviceResponse.data.userDeviceId)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                // save user device id based on tenant
                                DBHelper.shared.setUserDeviceId(userDeviceId: validateDeviceResponse.data.userDeviceId, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                
                                DispatchQueue.main.async {
                                    callback(Result.success(result: validateDeviceResponse))
                                }
                                
                                break
                            case .failure(let error):
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                break
                            }
                        }
                    }
                    else {
                        timerCount = timerCount + 1
                    }
                })
            }
        }
    }
    
    // Web to Mobile
    // enroll PatternRecognition from properties
    public func enrollPatternRecognition(access_token: String, enrollPatternEntity: EnrollPatternEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollPatternResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil {
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
        if (enrollPatternEntity.statusId == "" || enrollPatternEntity.userDeviceId == "" || enrollPatternEntity.verifierPassword == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or userDeviceId or verifierPassword must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.PATTERN.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // call enroll service
        PatternVerificationService.shared.enrollPattern(accessToken:access_token, enrollPatternEntity: enrollPatternEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Enroll Pattern service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let enrollResponse):
                // log success
                let loggerMessage = "Enroll Pattern success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // default set intermediate id to empty
                Cidaas.intermediate_verifiation_id = intermediate_id
                
                var timer: Timer = Timer()
                var timerCount: Int16 = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer_response) in
                    if (timerCount > 10) {
                        timerCount = 0
                        timer.invalidate()
                        
                        let error = WebAuthError.shared.notificationTimeoutException()
                        
                        // log error
                        let loggerMessage = "Device Verification failure. Notification timeout : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    }
                    if (Cidaas.intermediate_verifiation_id != "") {
                        timerCount = 0
                        timer.invalidate()
                        
                        // construct object
                        let enrollPatternEntity = EnrollPatternEntity()
                        enrollPatternEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call enroll service
                        PatternVerificationService.shared.enrollPattern(accessToken: access_token, enrollPatternEntity: enrollPatternEntity, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // log error
                                let loggerMessage = "Enroll Pattern  with usage pass service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                // return failure callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let enrollResponse):
                                // log success
                                let loggerMessage = "Enroll Pattern with usage pass success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                DispatchQueue.main.async {
                                    callback(Result.success(result: enrollResponse))
                                }
                            }
                        }
                    }
                    else {
                        timerCount = timerCount + 1
                    }
                })
            }
        }
    }
    
    
    // login with pattern recognition from properties
    public func loginWithPatternRecognition(pattern: String, email : String, mobile: String, sub: String, trackId: String, requestId: String, usageType: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        
        if (DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId") == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "There is no physical verification configured in this mobile"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.PATTERN.rawValue
        self.authenticationType = AuthenticationTypes.LOGIN.rawValue
        
        // validating fields
        if ((email == "" && sub == "" && mobile == "") || requestId == "" || pattern == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "email or sub or mobile or requestId or pattern must not be empty"
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
        var initiatePatternEntity = InitiatePatternEntity()
        initiatePatternEntity.email = email
        initiatePatternEntity.sub = sub
        initiatePatternEntity.usageType = usageType
        initiatePatternEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call initiatePattern service
        PatternVerificationService.shared.initiatePattern(initiatePatternEntity: initiatePatternEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate Pattern service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate Pattern service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                self.statusId = serviceResponse.data.statusId
                self.sub = sub
                
                
                var timer: Timer = Timer()
                var timerCount: Int16 = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer_response) in
                    if (timerCount > 10) {
                        timerCount = 0
                        timer.invalidate()
                        
                        let error = WebAuthError.shared.notificationTimeoutException()
                        
                        // log error
                        let loggerMessage = "Device Verification failure. Notification timeout : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    }
                    if (Cidaas.intermediate_verifiation_id != "") {
                        timerCount = 0
                        timer.invalidate()
                        
                        // construct object
                        initiatePatternEntity = InitiatePatternEntity()
                        initiatePatternEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call initiatePattern with usage service
                        PatternVerificationService.shared.initiatePattern(initiatePatternEntity: initiatePatternEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiatePatternResponse):
                                // log success
                                let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiatePatternResponse.data.statusId)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                self.statusId = initiatePatternResponse.data.statusId
                                
                                // call authenticatePattern service
                                PatternVerificationController.shared.verifyPattern(pattern: pattern, statusId: self.statusId, properties: properties) {
                                    switch $0 {
                                    case .failure(let error):
                                        // return failure callback
                                        DispatchQueue.main.async {
                                            callback(Result.failure(error: error))
                                        }
                                        return
                                    case .success(let patternResponse):
                                        // log success
                                        let mfaContinueEntity = MFAContinueEntity()
                                        mfaContinueEntity.requestId = requestId
                                        mfaContinueEntity.sub = patternResponse.data.sub
                                        mfaContinueEntity.trackId = trackId
                                        mfaContinueEntity.trackingCode = patternResponse.data.trackingCode
                                        mfaContinueEntity.verificationType = "PATTERN"
                                        
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
                                
                                break
                            case .failure(let error):
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                break
                            }
                        }
                    }
                    else {
                        timerCount = timerCount + 1
                    }
                })
                
            }
        }
    }
    
    public func verifyPattern(pattern: String, statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticatePatternResponseEntity>) -> Void) {
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
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.PATTERN.rawValue
        self.authenticationType = AuthenticationTypes.LOGIN.rawValue
        
        // validating fields
        if (statusId == "" || pattern == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or pattern must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        var authenticatePatternEntity = AuthenticatePatternEntity()
        authenticatePatternEntity.statusId = statusId
        authenticatePatternEntity.verifierPassword = pattern
        
        // getting user device id
        authenticatePatternEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call authenticatePattern service
        PatternVerificationService.shared.authenticatePattern(authenticatePatternEntity: authenticatePatternEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Authenticate Pattern service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let patternResponse):
                // log success
                let loggerMessage = "Authenticate Pattern success : " + "Current Status - " + String(describing: patternResponse.data.current_status)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                
                var timer: Timer = Timer()
                var timerCount: Int16 = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer_response) in
                    if (timerCount > 10) {
                        timerCount = 0
                        timer.invalidate()
                        
                        let error = WebAuthError.shared.notificationTimeoutException()
                        
                        // log error
                        let loggerMessage = "Device Verification failure. Notification timeout : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    }
                    if (Cidaas.intermediate_verifiation_id != "") {
                        timerCount = 0
                        timer.invalidate()
                        
                        // construct object
                        authenticatePatternEntity = AuthenticatePatternEntity()
                        authenticatePatternEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call authenticate with usage service
                        PatternVerificationService.shared.authenticatePattern(authenticatePatternEntity: authenticatePatternEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiatePatternResponse):
                                // log success
                                let loggerMessage = "Authenticate with usage pass success : " + "Status Id - " + String(describing: initiatePatternResponse.data.sub)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                // return success callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: patternResponse))
                                }
                                
                                break
                            case .failure(let error):
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                break
                            }
                        }
                    }
                    else {
                        timerCount = timerCount + 1
                    }
                })
            }
        }
    }
}
