//
//  TOTPVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import OneTimePassword

public class TOTPVerificationController {
    
    // local variables
    private var statusId: String
    private var authenticationType: String
    private var sub: String
    private var email: String
    private var verificationType: String
    private var secret: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : TOTPVerificationController = TOTPVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.email = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.verificationType = ""
        self.secret = ""
    }
    
    // configure TOTP from properties
    public func configureTOTP(sub: String, logoUrl: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollTOTPResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.TOTP.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.sub = sub
        
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
                var setupTOTPEntity = SetupTOTPEntity()
                setupTOTPEntity.logoUrl = logoUrl
                
                // call setupTOTP service
                TOTPVerificationService.shared.setupTOTP(accessToken: tokenResponse.data.access_token, setupTOTPEntity: setupTOTPEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure TOTP service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure TOTP service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                                setupTOTPEntity = SetupTOTPEntity()
                                setupTOTPEntity.usage_pass = Cidaas.intermediate_verifiation_id
                                
                                // call validate device
                                TOTPVerificationService.shared.setupTOTP(accessToken: tokenResponse.data.access_token, setupTOTPEntity: setupTOTPEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let validateDeviceResponse):
                                        // log success
                                        let loggerMessage = "Validate device success : " + "Status Id - " + String(describing: validateDeviceResponse.data.st)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        self.statusId = validateDeviceResponse.data.st
                                        
                                        // save user device id based on tenant
                                        DBHelper.shared.setUserDeviceId(userDeviceId: validateDeviceResponse.data.udi, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                        
                                        // save qrcode
                                        DBHelper.shared.setTOTPSecret(secret: validateDeviceResponse.data.secret, name: validateDeviceResponse.data.d, issuer: validateDeviceResponse.data.issuer, key: self.sub)
                                        
                                        let enrollTOTPEntity = EnrollTOTPEntity()
                                        enrollTOTPEntity.statusId = self.statusId
                                        self.secret = DBHelper.shared.getTOTPSecret(key: self.sub)
                                            
                                        enrollTOTPEntity.verifierPassword = self.gettingTOTPCode(url: URL(string: self.secret)!).totp_string
                                        
                                        // call enroll totpResponse service
                                        TOTPVerificationController.shared.enrollTOTP(access_token: tokenResponse.data.access_token, enrollTOTPEntity: enrollTOTPEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let enrollResponse):
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
    // scanned TOTP from properties
    public func scannedTOTP(statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<ScannedTOTPResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.TOTP.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // construct object
        var scannedTOTPEntity = ScannedTOTPEntity()
        scannedTOTPEntity.statusId = statusId
        
        // call scannedTOTP service
        TOTPVerificationService.shared.scannedTOTP(scannedTOTPEntity: scannedTOTPEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Scanned TOTP service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Scanned TOTP service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                        scannedTOTPEntity = ScannedTOTPEntity()
                        scannedTOTPEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call validate device
                        TOTPVerificationService.shared.scannedTOTP(scannedTOTPEntity: scannedTOTPEntity, properties: properties) {
                            switch $0 {
                            case .success(let validateDeviceResponse):
                                // log success
                                let loggerMessage = "Scanned TOTP with usage pass service success : " + "User device Id - " + String(describing: validateDeviceResponse.data.userDeviceId)
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
    // enroll TOTP from properties
    public func enrollTOTP(access_token: String, enrollTOTPEntity: EnrollTOTPEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollTOTPResponseEntity>) -> Void) {
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
        
        if enrollTOTPEntity.userDeviceId == "" {
            enrollTOTPEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        }
        
        // validating fields
        if (enrollTOTPEntity.statusId == "" || enrollTOTPEntity.userDeviceId == "" || enrollTOTPEntity.verifierPassword == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or userDeviceId or verifierPassword must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.TOTP.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // call enroll service
        TOTPVerificationService.shared.enrollTOTP(accessToken:access_token, enrollTOTPEntity: enrollTOTPEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Enroll TOTP service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let enrollResponse):
                // log success
                let loggerMessage = "Enroll TOTP success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
                        let enrollTOTPEntity = EnrollTOTPEntity()
                        enrollTOTPEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call enroll service
                        TOTPVerificationService.shared.enrollTOTP(accessToken: access_token, enrollTOTPEntity: enrollTOTPEntity, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // log error
                                let loggerMessage = "Enroll TOTP  with usage pass service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                // return failure callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let enrollResponse):
                                // log success
                                let loggerMessage = "Enroll TOTP with usage pass success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
    
    
    // login with totp recognition from properties
    public func loginWithTOTP(email : String, mobile: String, sub: String, trackId: String, requestId: String, usageType: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.TOTP.rawValue
        self.authenticationType = AuthenticationTypes.LOGIN.rawValue
        self.sub = sub
        self.email = email
        
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
        var initiateTOTPEntity = InitiateTOTPEntity()
        initiateTOTPEntity.email = email
        initiateTOTPEntity.sub = sub
        initiateTOTPEntity.usageType = usageType
        initiateTOTPEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call initiateTOTP service
        TOTPVerificationService.shared.initiateTOTP(initiateTOTPEntity: initiateTOTPEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate TOTP service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate TOTP service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
                        initiateTOTPEntity = InitiateTOTPEntity()
                        initiateTOTPEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call initiateTOTP with usage service
                        TOTPVerificationService.shared.initiateTOTP(initiateTOTPEntity: initiateTOTPEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateTOTPResponse):
                                // log success
                                let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateTOTPResponse.data.statusId)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                self.statusId = initiateTOTPResponse.data.statusId
                                
                                // getting secret
                                self.secret = DBHelper.shared.getTOTPSecret(key: self.sub)
                                
                                // construct object
                                var authenticateTOTPEntity = AuthenticateTOTPEntity()
                                authenticateTOTPEntity.statusId = self.statusId
                                
                                // getting user device id
                                authenticateTOTPEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                
                                // generate token
                                authenticateTOTPEntity.verifierPassword = self.gettingTOTPCode(url: URL(string: self.secret)!).totp_string
                                
                                // call authenticateTOTP service
                                TOTPVerificationService.shared.authenticateTOTP(authenticateTOTPEntity: authenticateTOTPEntity, properties: properties) {
                                    switch $0 {
                                    case .failure(let error):
                                        // log error
                                        let loggerMessage = "Authenticate TOTP service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                        
                                        // return failure callback
                                        DispatchQueue.main.async {
                                            callback(Result.failure(error: error))
                                        }
                                        return
                                    case .success(let totpResponse):
                                        // log success
                                        let loggerMessage = "Authenticate TOTP success : " + "Tracking Code - " + String(describing: totpResponse.data.trackingCode + ", Sub - " + String(describing: totpResponse.data.sub))
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
                                                authenticateTOTPEntity = AuthenticateTOTPEntity()
                                                authenticateTOTPEntity.usage_pass = Cidaas.intermediate_verifiation_id
                                                
                                                // call authenticate with usage service
                                                TOTPVerificationService.shared.authenticateTOTP(authenticateTOTPEntity: authenticateTOTPEntity, properties: properties) {
                                                    switch $0 {
                                                    case .success(let initiateTOTPResponse):
                                                        // log success
                                                        let loggerMessage = "Authenticate with usage pass success : " + "Status Id - " + String(describing: initiateTOTPResponse.data.sub)
                                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                        
                                                        let mfaContinueEntity = MFAContinueEntity()
                                                        mfaContinueEntity.requestId = requestId
                                                        mfaContinueEntity.sub = initiateTOTPResponse.data.sub
                                                        mfaContinueEntity.trackId = trackId
                                                        mfaContinueEntity.trackingCode = initiateTOTPResponse.data.trackingCode
                                                        mfaContinueEntity.verificationType = "TOTP"
                                                        
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
    
    public func gettingTOTPCode(url: URL) -> TOTP {
        let totp = TOTP()
        if let token = Token(url: url) {
            totp.totp_string = token.currentPassword ?? ""
            totp.name = token.name
            totp.issuer = token.issuer
            
            // time based actions
            var currentTime = NSDate().timeIntervalSince1970
            currentTime = currentTime.truncatingRemainder(dividingBy: 30)
            let finalCurrentTime = 30 - Int(currentTime)
            totp.timer_count = String(format:"%02d", finalCurrentTime)
            
            return totp
        }
        return TOTP()
    }
}
