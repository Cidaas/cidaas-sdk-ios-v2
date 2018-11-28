//
//  FaceVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class FaceVerificationController {
    
    // local variables
    private var statusId: String
    private var authenticationType: String
    private var sub: String
    private var verificationType: String
    private var usageType: String = UsageTypes.MFA.rawValue
    
    // shared instance
    public static var shared : FaceVerificationController = FaceVerificationController()
    
    // constructor
    public init() {
        self.sub = ""
        self.statusId = ""
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        self.verificationType = ""
    }
    
    // configure Face from properties
    public func configureFace(sub: String, photo: UIImage, logoUrl: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.FACE.rawValue
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
                var setupFaceEntity = SetupFaceEntity()
                setupFaceEntity.logoUrl = logoUrl
                
                // call setupFace service
                FaceVerificationService.shared.setupFace(accessToken: tokenResponse.data.access_token, setupFaceEntity: setupFaceEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Configure Face service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Configure Face service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                                setupFaceEntity = SetupFaceEntity()
                                setupFaceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                                
                                // call validate device
                                FaceVerificationService.shared.setupFace(accessToken: tokenResponse.data.access_token, setupFaceEntity: setupFaceEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let validateDeviceResponse):
                                        // log success
                                        let loggerMessage = "Validate device success : " + "Status Id - " + String(describing: validateDeviceResponse.data.st)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        // save user device id based on tenant
                                        DBHelper.shared.setUserDeviceId(userDeviceId: validateDeviceResponse.data.udi, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                        
                                        self.statusId = validateDeviceResponse.data.st
                                        
                                        let enrollFaceEntity = EnrollFaceEntity()
                                        enrollFaceEntity.statusId = self.statusId
                                        
                                        // call enroll service
                                        FaceVerificationController.shared.enrollFaceRecognition(access_token: tokenResponse.data.access_token, photo: photo, enrollFaceEntity: enrollFaceEntity, properties: properties) {
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
    // scanned Face from properties
    public func scannedFaceRecognition(statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<ScannedFaceResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.FACE.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        // construct object
        var scannedFaceEntity = ScannedFaceEntity()
        scannedFaceEntity.statusId = statusId
        
        // call scannedFace service
        FaceVerificationService.shared.scannedFace(scannedFaceEntity: scannedFaceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Scanned Face service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Scanned Face service success : " + "Current Status  - " + String(describing: serviceResponse.data.current_status)
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
                        scannedFaceEntity = ScannedFaceEntity()
                        scannedFaceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call validate device
                        FaceVerificationService.shared.scannedFace(scannedFaceEntity: scannedFaceEntity, properties: properties) {
                            switch $0 {
                            case .success(let validateDeviceResponse):
                                // log success
                                let loggerMessage = "Scanned Face with usage pass service success : " + "User device Id - " + String(describing: validateDeviceResponse.data.userDeviceId)
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
    // enroll Face from properties
    public func enrollFaceRecognition(sub: String = "", access_token: String, photo: UIImage, enrollFaceEntity: EnrollFaceEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
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
        
        if enrollFaceEntity.userDeviceId == "" {
            enrollFaceEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        }
        
        // validating fields
        if (enrollFaceEntity.statusId == "" || enrollFaceEntity.userDeviceId == "") {
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
        self.verificationType = VerificationTypes.FACE.rawValue
        self.authenticationType = AuthenticationTypes.CONFIGURE.rawValue
        
        if access_token == "" {
            Cidaas.shared.getAccessToken(sub: sub) {
                switch $0 {
                case .success(let successResponse):
                    self.enrollFaceAPI(access_token: successResponse.data.access_token, photo: photo, enrollFaceEntity: enrollFaceEntity, properties: properties, callback: callback)
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
            self.enrollFaceAPI(access_token: access_token, photo: photo, enrollFaceEntity: enrollFaceEntity, properties: properties, callback: callback)
        }
    }
    
    private func enrollFaceAPI(access_token: String, photo: UIImage, enrollFaceEntity: EnrollFaceEntity, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
        // call enroll service
        FaceVerificationService.shared.enrollFace(accessToken:access_token, photo: photo, enrollFaceEntity: enrollFaceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Enroll Face service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let enrollResponse):
                // log success
                let loggerMessage = "Enroll Face success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
                        let enrollFaceEntity = EnrollFaceEntity()
                        enrollFaceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call enroll service
                        FaceVerificationService.shared.enrollFace(accessToken:access_token, photo: photo, enrollFaceEntity: enrollFaceEntity, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // log error
                                let loggerMessage = "Enroll Face  with usage pass service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                
                                // return failure callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let enrollResponse):
                                // log success
                                let loggerMessage = "Enroll Face with usage pass success : " + "Tracking Code - " + String(describing: enrollResponse.data.trackingCode + ", Sub - " + String(describing: enrollResponse.data.sub))
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
    
    
    
    // login with Face from properties
    public func loginWithFace(email : String, mobile: String, sub: String, trackId: String, requestId: String, photo: UIImage, usageType: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.FACE.rawValue
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
        var initiateFaceEntity = InitiateFaceEntity()
        initiateFaceEntity.email = email
        initiateFaceEntity.sub = sub
        initiateFaceEntity.usageType = usageType
        initiateFaceEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call initiateFace service
        FaceVerificationService.shared.initiateFace(initiateFaceEntity: initiateFaceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate Face service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate Face service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
                        initiateFaceEntity = InitiateFaceEntity()
                        initiateFaceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call initiateFace with usage service
                        FaceVerificationService.shared.initiateFace(initiateFaceEntity: initiateFaceEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateFaceResponse):
                                // log success
                                let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateFaceResponse.data.statusId)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                self.statusId = initiateFaceResponse.data.statusId
                                
                                // call authenticateFace service
                                FaceVerificationController.shared.verifyFace(photo: photo, statusId: self.statusId, properties: properties) {
                                    switch $0 {
                                    case .failure(let error):
                                        // return failure callback
                                        DispatchQueue.main.async {
                                            callback(Result.failure(error: error))
                                        }
                                        return
                                    case .success(let FaceResponse):
                                        let mfaContinueEntity = MFAContinueEntity()
                                        mfaContinueEntity.requestId = requestId
                                        mfaContinueEntity.sub = FaceResponse.data.sub
                                        mfaContinueEntity.trackId = trackId
                                        mfaContinueEntity.trackingCode = FaceResponse.data.trackingCode
                                        mfaContinueEntity.verificationType = "FACE"
                                        
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
    
    public func verifyFace(photo: UIImage, statusId: String, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticateFaceResponseEntity>) -> Void) {
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
        self.verificationType = VerificationTypes.FACE.rawValue
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
        var authenticateFaceEntity = AuthenticateFaceEntity()
        authenticateFaceEntity.statusId = statusId
        
        // getting user device id
        authenticateFaceEntity.userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
        
        // call authenticateFace service
        FaceVerificationService.shared.authenticateFace(photo: photo, authenticateFaceEntity: authenticateFaceEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Authenticate Face service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let faceResponse):
                // log success
                let loggerMessage = "Authenticate Face success : " + "Tracking Code - " + String(describing: faceResponse.data.trackingCode + ", Sub - " + String(describing: faceResponse.data.sub))
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
                        authenticateFaceEntity = AuthenticateFaceEntity()
                        authenticateFaceEntity.usage_pass = Cidaas.intermediate_verifiation_id
                        
                        // call authenticate with usage service
                        FaceVerificationService.shared.authenticateFace(photo: photo, authenticateFaceEntity: authenticateFaceEntity, properties: properties) {
                            switch $0 {
                            case .success(let initiateFaceResponse):
                                // log success
                                let loggerMessage = "Authenticate with usage pass success : " + "Status Id - " + String(describing: initiateFaceResponse.data.sub)
                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                
                                // return success callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: initiateFaceResponse))
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
