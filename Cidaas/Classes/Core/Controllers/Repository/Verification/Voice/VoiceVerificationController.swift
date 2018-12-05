//
//  VoiceVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class VoiceVerificationController {
    
    // local variables
    private var statusId: String
    private var authenticationType: String
    private var sub: String
    private var verificationType: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : VoiceVerificationController = VoiceVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.verificationType = ""
    }
    
    // configure Voice from properties
    public func configureVoice(sub: String, voice: Data, logoUrl: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollVoiceResponseEntity>) -> Void) {
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
                var setupVoiceEntity = SetupVoiceEntity()
                setupVoiceEntity.logoUrl = logoUrl
                
                // call setupVoice service
                VoiceVerificationService.shared.setupVoice(accessToken: tokenResponse.data.access_token, setupVoiceEntity: setupVoiceEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure Voice service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure Voice service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                                setupVoiceEntity = SetupVoiceEntity()
                                setupVoiceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                                
                                // call validate device
                                VoiceVerificationService.shared.setupVoice(accessToken: tokenResponse.data.access_token, setupVoiceEntity: setupVoiceEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let validateDeviceResponse):
                                        // log success
                                        let loggerMessage = "Validate device success : " + "Status Id - " + String(describing: validateDeviceResponse.data.st)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        // save user device id based on tenant
                                        DBHelper.shared.setUserDeviceId(userDeviceId: validateDeviceResponse.data.udi, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                        
                                        self.statusId = validateDeviceResponse.data.st
                                        
                                        let enrollVoiceEntity = EnrollVoiceEntity()
                                        enrollVoiceEntity.statusId = self.statusId
                                        
                                        // call enroll service
                                        VoiceVerificationController.shared.enrollVoiceRecognition(access_token: tokenResponse.data.access_token, voice: voice, enrollVoiceEntity: enrollVoiceEntity, properties: properties) {
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
    // scanned Voice from properties
    public func scannedVoiceRecognition(statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<ScannedVoiceResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.VOICE.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // construct object
        var scannedVoiceEntity = ScannedVoiceEntity()
        scannedVoiceEntity.statusId = statusId
        
        // call scannedVoice service
        VoiceVerificationService.shared.scannedVoice(scannedVoiceEntity: scannedVoiceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Scanned Voice service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Scanned Voice service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                        scannedVoiceEntity = ScannedVoiceEntity()
                        scannedVoiceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call validate device
                        VoiceVerificationService.shared.scannedVoice(scannedVoiceEntity: scannedVoiceEntity, properties: properties) {
                            switch $0 {
                            case .success(let validateDeviceResponse):
                                // log success
                                let loggerMessage = "Scanned Voice with usage pass service success : " + "User device Id - " + String(describing: validateDeviceResponse.data.userDeviceId)
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
    // enroll Voice from properties
    public func enrollVoiceRecognition(sub: String = "", access_token: String, voice: Data, enrollVoiceEntity: EnrollVoiceEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollVoiceResponseEntity>) -> Void) {
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
        
        if enrollVoiceEntity.userDeviceId == "" {
            enrollVoiceEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        }
        
        // validating fields
        if (enrollVoiceEntity.statusId == "" || enrollVoiceEntity.userDeviceId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "statusId or userDeviceId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        if access_token == "" {
            if sub == "" {
                let error = WebAuthError.shared.propertyMissingException()
                error.errorMessage = "access_token or sub must not be empty"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        
        // default set intermediate id to empty
        Cidaas.intermediate_verifiation_id = intermediate_id
        self.verificationType = VerificationTypes.VOICE.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        if access_token == "" {
            Cidaas.shared.getAccessToken(sub: sub) {
                switch $0 {
                case .success(let successResponse):
                    self.enrollVoiceAPI(access_token: successResponse.data.access_token, voice: voice, enrollVoiceEntity: enrollVoiceEntity, properties: properties, callback: callback)
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    break
                }
            }
        }
        else {
            self.enrollVoiceAPI(access_token: access_token, voice: voice, enrollVoiceEntity: enrollVoiceEntity, properties: properties, callback: callback)
        }
    }
    
    private func enrollVoiceAPI(access_token: String, voice: Data, enrollVoiceEntity: EnrollVoiceEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollVoiceResponseEntity>) -> Void) {
        // call enroll service
        VoiceVerificationService.shared.enrollVoice(accessToken:access_token, voice: voice, enrollVoiceEntity: enrollVoiceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Enroll Voice service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let enrollResponse):
                // log success
                let loggerMessage = "Enroll Voice success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
                        let enrollVoiceEntity = EnrollVoiceEntity()
                        enrollVoiceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call enroll service
                        VoiceVerificationService.shared.enrollVoice(accessToken:access_token, voice: voice, enrollVoiceEntity: enrollVoiceEntity, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // log error
                                let loggerMessage = "Enroll Voice  with usage pass service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                // return failure callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let enrollResponse):
                                // log success
                                let loggerMessage = "Enroll Voice with usage pass success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
    
    // login with Voice from properties
    public func loginWithVoice(email : String, mobile: String, sub: String, trackId: String, requestId: String, voice: Data, usageType: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        let initiateVoiceEntity = InitiateVoiceEntity()
        initiateVoiceEntity.email = email
        initiateVoiceEntity.sub = sub
        initiateVoiceEntity.usageType = usageType
        initiateVoiceEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call initiateVoice service
        VoiceVerificationService.shared.initiateVoice(initiateVoiceEntity: initiateVoiceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate Voice service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate Voice service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
                        initiateVoiceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call initiateVoice with usage service
                        VoiceVerificationService.shared.initiateVoice(initiateVoiceEntity: initiateVoiceEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateVoiceResponse):
                                // log success
                                let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateVoiceResponse.data.statusId)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                self.statusId = initiateVoiceResponse.data.statusId
                                
                                
                                // call authenticateVoice service
                                VoiceVerificationController.shared.verifyVoice(voice: voice, statusId: self.statusId, properties: properties) {
                                    switch $0 {
                                    case .failure(let error):
                                        // return failure callback
                                        DispatchQueue.main.async {
                                            callback(Result.failure(error: error))
                                        }
                                        return
                                    case .success(let VoiceResponse):
                                        let mfaContinueEntity = MFAContinueEntity()
                                        mfaContinueEntity.requestId = requestId
                                        mfaContinueEntity.sub = VoiceResponse.data.sub
                                        mfaContinueEntity.trackId = trackId
                                        mfaContinueEntity.trackingCode = VoiceResponse.data.trackingCode
                                        mfaContinueEntity.verificationType = "VOICE"
                                        
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
    
    public func verifyVoice(voice: Data, statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticateVoiceResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.VOICE.rawValue
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
        var authenticateVoiceEntity = AuthenticateVoiceEntity()
        authenticateVoiceEntity.statusId = statusId
        
        // getting user device id
        authenticateVoiceEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call authenticateVoice service
        VoiceVerificationService.shared.authenticateVoice(voice: voice, authenticateVoiceEntity: authenticateVoiceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Authenticate Voice service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let patternResponse):
                // log success
                let loggerMessage = "Authenticate Voice success : " + "Tracking Code - " + String(describing: patternResponse.data.trackingCode + ", Sub - " + String(describing: patternResponse.data.sub))
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
                        authenticateVoiceEntity = AuthenticateVoiceEntity()
                        authenticateVoiceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call authenticate with usage service
                        VoiceVerificationService.shared.authenticateVoice(voice: voice, authenticateVoiceEntity: authenticateVoiceEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateVoiceResponse):
                                // log success
                                let loggerMessage = "Authenticate with usage pass success : " + "Status Id - " + String(describing: initiateVoiceResponse.data.sub)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                // return success callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: initiateVoiceResponse))
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
