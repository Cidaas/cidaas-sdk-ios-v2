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
                        let loggerMessage = "Configure TouchId service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
                                        
                                        let scannedTouchIdEntity = ScannedTouchEntity()
                                        scannedTouchIdEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                        scannedTouchIdEntity.statusId = self.statusId
                                        
                                        // call scanned TouchId service
                                        TouchIdVerificationService.shared.scannedTouchId(accessToken:tokenResponse.data.access_token, scannedTouchIdEntity: scannedTouchIdEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // log error
                                                let loggerMessage = "TouchId Scanned service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                                
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let serviceResponse):
                                                // log success
                                                let loggerMessage = "Scanned TouchId success : " + "User Device Id - " + String(describing: serviceResponse.data.userDeviceId)
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
                                                // save user device id based on tenant
                                                DBHelper.shared.setUserDeviceId(userDeviceId: serviceResponse.data.userDeviceId, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                                
                                                // construct method
                                                let enrollTouchIdEntity = EnrollTouchEntity()
                                                enrollTouchIdEntity.statusId = self.statusId
                                                enrollTouchIdEntity.userDeviceId = serviceResponse.data.userDeviceId
                                                
                                                // call enroll service
                                                TouchIdVerificationService.shared.enrollTouchId(accessToken:tokenResponse.data.access_token, enrollTouchIdEntity: enrollTouchIdEntity, properties: properties) {
                                                    switch $0 {
                                                    case .failure(let error):
                                                        // log error
                                                        let loggerMessage = "Enroll TouchId service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                                        
                                                        // return failure callback
                                                        DispatchQueue.main.async {
                                                            callback(Result.failure(error: error))
                                                        }
                                                        return
                                                    case .success(let enrollResponse):
                                                        // log success
                                                        let loggerMessage = "Enroll TouchId success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
            error.error = "There is no physical verification configured in this mobile"
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
        
        
        // construct object
        let initiateTouchIdEntity = InitiateTouchEntity()
        initiateTouchIdEntity.email = email
        initiateTouchIdEntity.sub = sub
        initiateTouchIdEntity.usageType = usageType
        
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
                                
                                initiateTouchIdEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                
                                // call initiateTouchId with usage service
                                TouchIdVerificationService.shared.initiateTouchId(initiateTouchIdEntity: initiateTouchIdEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let initiateTouchIdResponse):
                                        // log success
                                        let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateTouchIdResponse.data.statusId)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        self.statusId = initiateTouchIdResponse.data.statusId
                                        
                                        // construct object
                                        let authenticateTouchIdEntity = AuthenticateTouchEntity()
                                        authenticateTouchIdEntity.statusId = self.statusId
                                        // getting user device id
                                        authenticateTouchIdEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                        
                                        // call authenticateTouchId service
                                        TouchIdVerificationService.shared.authenticateTouchId(authenticateTouchIdEntity: authenticateTouchIdEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // log error
                                                let loggerMessage = "Authenticate TouchId service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                                
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let TouchIdResponse):
                                                // log success
                                                let loggerMessage = "Authenticate TouchId success : " + "Tracking Code - " + String(describing: TouchIdResponse.data.trackingCode + ", Sub - " + String(describing: TouchIdResponse.data.sub))
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
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
    
    public func verifyTouchId(statusId: String, properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticateTouchResponseEntity>) -> Void) {
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
        if (statusId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "statusId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let authenticateTouchEntity = AuthenticateTouchEntity()
        authenticateTouchEntity.statusId = self.statusId
        
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
            case .success(let patternResponse):
                // log success
                let loggerMessage = "Authenticate Touch success : " + "Tracking Code - " + String(describing: patternResponse.data.trackingCode + ", Sub - " + String(describing: patternResponse.data.sub))
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return success callback
                DispatchQueue.main.async {
                    callback(Result.success(result: patternResponse))
                }
            }
        }
    }
}
