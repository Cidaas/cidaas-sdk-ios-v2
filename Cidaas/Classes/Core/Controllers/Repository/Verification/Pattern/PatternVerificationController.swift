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
            error.error = "sub or pattern must not be empty"
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
                let setupPatternEntity = SetupPatternEntity()
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
                        let loggerMessage = "Configure Pattern service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        self.statusId = serviceResponse.data.statusId
                        
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
                                let validateDeviceEntity = ValidateDeviceEntity()
                                validateDeviceEntity.intermediate_verifiation_id = Cidaas.intermediate_verifiation_id
                                validateDeviceEntity.statusId = self.statusId
                                
                                // call validate device
                                DeviceVerificationService.shared.validateDevice(validateDeviceEntity: validateDeviceEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let validateDeviceResponse):
                                        // log success
                                        let loggerMessage = "Validate device success : " + "Usage pass - " + String(describing: validateDeviceResponse.data.usage_pass)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        let scannedPatternEntity = ScannedPatternEntity()
                                        scannedPatternEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                        scannedPatternEntity.statusId = self.statusId
                                        
                                        // call scanned pattern service
                                        PatternVerificationService.shared.scannedPattern(accessToken:tokenResponse.data.access_token, scannedPatternEntity: scannedPatternEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // log error
                                                let loggerMessage = "Pattern Scanned service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                                
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let serviceResponse):
                                                // log success
                                                let loggerMessage = "Scanned Pattern success : " + "User Device Id - " + String(describing: serviceResponse.data.userDeviceId)
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
                                                // save user device id based on tenant
                                                DBHelper.shared.setUserDeviceId(userDeviceId: serviceResponse.data.userDeviceId, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                                
                                                // construct method
                                                let enrollPatternEntity = EnrollPatternEntity()
                                                enrollPatternEntity.statusId = self.statusId
                                                enrollPatternEntity.userDeviceId = serviceResponse.data.userDeviceId
                                                enrollPatternEntity.verifierPassword = pattern
                                                
                                                // call enroll service
                                                PatternVerificationService.shared.enrollPattern(accessToken:tokenResponse.data.access_token, enrollPatternEntity: enrollPatternEntity, properties: properties) {
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
                                                        
                                                        DispatchQueue.main.async {
                                                            callback(Result.success(result: enrollResponse))
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
            error.error = "There is no physical verification configured in this mobile"
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
            error.error = "email or sub or mobile or requestId or pattern must not be empty"
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
        let initiatePatternEntity = InitiatePatternEntity()
        initiatePatternEntity.email = email
        initiatePatternEntity.sub = sub
        initiatePatternEntity.usageType = usageType
        
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
                        let validateDeviceEntity = ValidateDeviceEntity()
                        validateDeviceEntity.intermediate_verifiation_id = Cidaas.intermediate_verifiation_id
                        validateDeviceEntity.statusId = self.statusId
                        
                        // call validate device
                        DeviceVerificationService.shared.validateDevice(validateDeviceEntity: validateDeviceEntity, properties: properties) {
                            switch $0 {
                            case .success(let validateDeviceResponse):
                                // log success
                                let loggerMessage = "Validate device success : " + "Usage pass - " + String(describing: validateDeviceResponse.data.usage_pass)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                initiatePatternEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                
                                // call initiatePattern with usage service
                                PatternVerificationService.shared.initiatePattern(initiatePatternEntity: initiatePatternEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let initiatePatternResponse):
                                        // log success
                                        let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiatePatternResponse.data.statusId)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        self.statusId = initiatePatternResponse.data.statusId
                                        
                                        // construct object
                                        let authenticatePatternEntity = AuthenticatePatternEntity()
                                        authenticatePatternEntity.statusId = self.statusId
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
                                                let loggerMessage = "Authenticate Pattern success : " + "Tracking Code - " + String(describing: patternResponse.data.trackingCode + ", Sub - " + String(describing: patternResponse.data.sub))
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
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
    
    public func verifyPattern(pattern: String, statusId: String, properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticatePatternResponseEntity>) -> Void) {
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
        if (statusId == "" || pattern == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "statusId or pattern must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let authenticatePatternEntity = AuthenticatePatternEntity()
        authenticatePatternEntity.statusId = self.statusId
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
                let loggerMessage = "Authenticate Pattern success : " + "Tracking Code - " + String(describing: patternResponse.data.trackingCode + ", Sub - " + String(describing: patternResponse.data.sub))
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return success callback
                DispatchQueue.main.async {
                    callback(Result.success(result: patternResponse))
                }
            }
        }
    }
}
