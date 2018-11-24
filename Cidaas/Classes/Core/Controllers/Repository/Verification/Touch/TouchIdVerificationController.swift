//
//  TouchIdVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import LocalAuthentication

public class TouchIdVerificationController {
    
    // local variables
    private var statusId: String
    private var authenticationType: String
    private var sub: String
    private var verificationType: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : TouchIdVerificationController = TouchIdVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.verificationType = ""
    }
    
    // configure TouchId from properties
    public func configureTouchId(sub: String, logoUrl: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollTouchResponseEntity>) -> Void) {
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
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.TOUCH.rawValue
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
                let setupTouchIdEntity = SetupTouchEntity()
                setupTouchIdEntity.logoUrl = logoUrl
                
                // call setupTouchId service
                TouchIdVerificationService.shared.setupTouchId(accessToken: tokenResponse.data.access_token, setupTouchIdEntity: setupTouchIdEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure TouchId service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure TouchId service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                                let setupTouchIdEntity = SetupTouchEntity()
                                setupTouchIdEntity.usage_pass = Cidaas.intermediate_verifiation_id
                                
                                // call validate device
                                TouchIdVerificationService.shared.setupTouchId(accessToken: tokenResponse.data.access_token, setupTouchIdEntity: setupTouchIdEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let validateDeviceResponse):
                                        // log success
                                        let loggerMessage = "Validate device success : " + "Status Id - " + String(describing: validateDeviceResponse.data.st)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        // save user device id based on tenant
                                        DBHelper.shared.setUserDeviceId(userDeviceId: validateDeviceResponse.data.udi, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                        
                                        self.statusId = validateDeviceResponse.data.st
                                        
                                        let enrollTouchEntity = EnrollTouchEntity()
                                        enrollTouchEntity.statusId = self.statusId
                                        
                                        // call scanned TouchId service
                                        TouchIdVerificationController.shared.enrollToucId(access_token:tokenResponse.data.access_token, enrollTouchEntity: enrollTouchEntity, properties: properties) {
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
    // scanned touch from properties
    public func scannedTouchId(statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<ScannedTouchResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.TOUCH.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // construct object
        var scannedTouchEntity = ScannedTouchEntity()
        scannedTouchEntity.statusId = statusId
        
        // call setupTouch service
        TouchIdVerificationService.shared.scannedTouchId(scannedTouchIdEntity: scannedTouchEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Scanned Touch Id service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Scanned Touch Id service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                        scannedTouchEntity = ScannedTouchEntity()
                        scannedTouchEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call validate device
                        TouchIdVerificationService.shared.scannedTouchId(scannedTouchIdEntity: scannedTouchEntity, properties: properties) {
                            switch $0 {
                            case .success(let validateDeviceResponse):
                                // log success
                                let loggerMessage = "Scanned Touch Id with usage pass service success : " + "User device Id - " + String(describing: validateDeviceResponse.data.userDeviceId)
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
    // enroll Touch Id from properties
    public func enrollToucId(access_token: String, enrollTouchEntity: EnrollTouchEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollTouchResponseEntity>) -> Void) {
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
        
        if enrollTouchEntity.userDeviceId == "" {
            enrollTouchEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        }
        
        // validating fields
        if (enrollTouchEntity.statusId == "" || enrollTouchEntity.userDeviceId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or userDeviceId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.TOUCH.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // call enroll service
        TouchIdVerificationService.shared.enrollTouchId(accessToken:access_token, enrollTouchIdEntity: enrollTouchEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Enroll Touch Id service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let enrollResponse):
                // log success
                let loggerMessage = "Enroll Touch Id success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
                        let enrollTouchEntity = EnrollTouchEntity()
                        enrollTouchEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call enroll service
                        TouchIdVerificationService.shared.enrollTouchId(accessToken: access_token, enrollTouchIdEntity: enrollTouchEntity, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // log error
                                let loggerMessage = "Enroll Touch Id  with usage pass service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                // return failure callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let enrollResponse):
                                // log success
                                let loggerMessage = "Enroll Touch Id with usage pass success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
    
    
    // login with TouchId from properties
    public func loginWithTouchId(email : String, mobile: String, sub: String, trackId: String, requestId: String, usageType: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.TOUCH.rawValue
        self.authenticationType = AuthenticationTypes.LOGIN.rawValue
        
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
        let initiateTouchIdEntity = InitiateTouchEntity()
        initiateTouchIdEntity.email = email
        initiateTouchIdEntity.sub = sub
        initiateTouchIdEntity.usageType = usageType
        initiateTouchIdEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call initiateTouchId service
        TouchIdVerificationService.shared.initiateTouchId(initiateTouchIdEntity: initiateTouchIdEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate TouchId service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate TouchId service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
                        initiateTouchIdEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call initiateTouchId with usage service
                        TouchIdVerificationService.shared.initiateTouchId(initiateTouchIdEntity: initiateTouchIdEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateTouchIdResponse):
                                // log success
                                let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateTouchIdResponse.data.statusId)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                self.statusId = initiateTouchIdResponse.data.statusId
                                
                                // call authenticateTouchId service
                                TouchIdVerificationController.shared.verifyTouchId(statusId: self.statusId, properties: properties) {
                                    switch $0 {
                                    case .failure(let error):
                                        // return failure callback
                                        DispatchQueue.main.async {
                                            callback(Result.failure(error: error))
                                        }
                                        return
                                    case .success(let TouchIdResponse):
                                        
                                        let mfaContinueEntity = MFAContinueEntity()
                                        mfaContinueEntity.requestId = requestId
                                        mfaContinueEntity.sub = TouchIdResponse.data.sub
                                        mfaContinueEntity.trackId = trackId
                                        mfaContinueEntity.trackingCode = TouchIdResponse.data.trackingCode
                                        mfaContinueEntity.verificationType = "TOUCHID"
                                        
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
    
    public func verifyTouchId(statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticateTouchResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.TOUCH.rawValue
        self.authenticationType = AuthenticationTypes.LOGIN.rawValue
        
        // validating fields
        if (statusId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        var authenticateTouchEntity = AuthenticateTouchEntity()
        authenticateTouchEntity.statusId = statusId
        
        // getting user device id
        authenticateTouchEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call authenticateTouch service
        TouchIdVerificationService.shared.authenticateTouchId(authenticateTouchIdEntity: authenticateTouchEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Authenticate Touch service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let touchResponse):
                // log success
                let loggerMessage = "Authenticate Touch success : " + "Tracking Code - " + String(describing: touchResponse.data.trackingCode + ", Sub - " + String(describing: touchResponse.data.sub))
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
                        authenticateTouchEntity = AuthenticateTouchEntity()
                        authenticateTouchEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call authenticate with usage service
                        TouchIdVerificationService.shared.authenticateTouchId(authenticateTouchIdEntity: authenticateTouchEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateTouchResponse):
                                // log success
                                let loggerMessage = "Authenticate with usage pass success : " + "Status Id - " + String(describing: initiateTouchResponse.data.sub)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                // return success callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: initiateTouchResponse))
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
