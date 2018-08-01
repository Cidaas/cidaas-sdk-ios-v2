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
    private var qrcode: String
    private var usageType: UsageTypes = UsageTypes.MFA
    
    // shared instance
    public static var shared : TOTPVerificationController = TOTPVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.email = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.verificationType = ""
        self.qrcode = ""
    }
    
    // configure TOTP from properties
    public func configureTOTP(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<EnrollTOTPResponseEntity>) -> Void) {
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
        Cidaas.intermediate_verifiation_id = ""
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
                let setupTOTPEntity = SetupTOTPEntity()
                
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
                        let loggerMessage = "Configure TOTP service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        self.statusId = serviceResponse.data.statusId
                        self.qrcode = serviceResponse.data.qrCode
                        
                        // save qrcode
                        DBHelper.shared.setTOTPSecret(qrcode: self.qrcode, key: self.sub)
                        
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
                                        
                                        let scannedTOTPEntity = ScannedTOTPEntity()
                                        scannedTOTPEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                        scannedTOTPEntity.statusId = self.statusId
                                        
                                        // call scanned pattern service
                                        TOTPVerificationService.shared.scannedTOTP(accessToken:tokenResponse.data.access_token, scannedTOTPEntity: scannedTOTPEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // log error
                                                let loggerMessage = "TOTP Scanned service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                                
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let serviceResponse):
                                                // log success
                                                let loggerMessage = "Scanned TOTP success : " + "User Device Id - " + String(describing: serviceResponse.data.userDeviceId)
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
                                                // save user device id based on tenant
                                                DBHelper.shared.setUserDeviceId(userDeviceId: serviceResponse.data.userDeviceId, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                                
                                                // construct method
                                                let enrollTOTPEntity = EnrollTOTPEntity()
                                                enrollTOTPEntity.statusId = self.statusId
                                                enrollTOTPEntity.userDeviceId = serviceResponse.data.userDeviceId
                                                
                                                // generate TOTP
                                                enrollTOTPEntity.verifierPassword = self.gettingTOTPCode(url: URL(string: self.qrcode)!).totp_string
                                                
                                                
                                                // call enroll service
                                                TOTPVerificationService.shared.enrollTOTP(accessToken:tokenResponse.data.access_token, enrollTOTPEntity: enrollTOTPEntity, properties: properties) {
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
    public func loginWithTOTP(email : String, sub: String, mobile: String, trackId: String, requestId: String, usageType: UsageTypes, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        Cidaas.intermediate_verifiation_id = ""
        self.verificationType = VerificationTypes.TOTP.rawValue
        self.authenticationType = AuthenticationTypes.LOGIN.rawValue
        self.sub = sub
        self.email = email
        
        // validating fields
        if ((email == "" && sub == "" && mobile == "") || requestId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "email or sub or mobile or requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        if (usageType == UsageTypes.MFA) {
            if (trackId == "") {
                let error = WebAuthError.shared.propertyMissingException()
                error.error = "trackId must not be empty"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        
        self.usageType = usageType
        
        // construct object
        let initiateTOTPEntity = InitiateTOTPEntity()
        initiateTOTPEntity.email = email
        initiateTOTPEntity.sub = sub
        initiateTOTPEntity.usageType = usageType.rawValue
        
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
                                
                                initiateTOTPEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                
                                // call initiateTOTP with usage service
                                TOTPVerificationService.shared.initiateTOTP(initiateTOTPEntity: initiateTOTPEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let initiateTOTPResponse):
                                        // log success
                                        let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateTOTPResponse.data.statusId)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        self.statusId = initiateTOTPResponse.data.statusId
                                        
                                        // construct object
                                        let authenticateTOTPEntity = AuthenticateTOTPEntity()
                                        authenticateTOTPEntity.statusId = self.statusId
                                        authenticateTOTPEntity.verifierPassword = self.gettingTOTPCode(url: URL(string: self.qrcode)!).totp_string
                                        
                                        // getting user device id
                                        authenticateTOTPEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomailURL"] ?? "OAuthUserDeviceId")
                                        
                                        // getting secret
                                        self.qrcode = DBHelper.shared.getTOTPSecret(key: self.sub)
                                        
                                        // generate token
                                        authenticateTOTPEntity.verifierPassword = self.gettingTOTPCode(url: URL(string: self.qrcode)!).totp_string
                                        
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
                                            case .success(let patternResponse):
                                                // log success
                                                let loggerMessage = "Authenticate TOTP success : " + "Tracking Code - " + String(describing: patternResponse.data.trackingCode + ", Sub - " + String(describing: patternResponse.data.sub))
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
                                                let mfaContinueEntity = MFAContinueEntity()
                                                mfaContinueEntity.requestId = requestId
                                                mfaContinueEntity.sub = patternResponse.data.sub
                                                mfaContinueEntity.trackId = trackId
                                                mfaContinueEntity.trackingCode = patternResponse.data.trackingCode
                                                mfaContinueEntity.verificationType = "TOTP"
                                                
                                                if(self.usageType == UsageTypes.PASSWORDLESS) {
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
