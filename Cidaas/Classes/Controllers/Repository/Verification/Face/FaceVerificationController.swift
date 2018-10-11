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
    public func configureFace(sub: String, photo: UIImage, intermediate_id: String = "", properties: Dictionary<String, String>, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
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
                let setupFaceEntity = SetupFaceEntity()
                
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
                        let loggerMessage = "Configure Face service success : " + "Status Id  - " + String(describing: serviceResponse.data.statusId)
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
                                        
                                        let scannedFaceEntity = ScannedFaceEntity()
                                        scannedFaceEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                        scannedFaceEntity.statusId = self.statusId
                                        
                                        // call scanned Face service
                                        FaceVerificationService.shared.scannedFace(accessToken:tokenResponse.data.access_token, scannedFaceEntity: scannedFaceEntity, properties: properties) {
                                            switch $0 {
                                            case .failure(let error):
                                                // log error
                                                let loggerMessage = "Face Scanned service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                                                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                                                
                                                // return failure callback
                                                DispatchQueue.main.async {
                                                    callback(Result.failure(error: error))
                                                }
                                                return
                                            case .success(let serviceResponse):
                                                // log success
                                                let loggerMessage = "Scanned Face success : " + "User Device Id - " + String(describing: serviceResponse.data.userDeviceId)
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
                                                // save user device id based on tenant
                                                DBHelper.shared.setUserDeviceId(userDeviceId: serviceResponse.data.userDeviceId, key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                                                
                                                // construct method
                                                let enrollFaceEntity = EnrollFaceEntity()
                                                enrollFaceEntity.statusId = self.statusId
                                                enrollFaceEntity.userDeviceId = serviceResponse.data.userDeviceId
                                                
                                                // call enroll service
                                                FaceVerificationService.shared.enrollFace(accessToken:tokenResponse.data.access_token, photo: photo, enrollFaceEntity: enrollFaceEntity, properties: properties) {
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
            error.error = "There is no physical verification configured in this mobile"
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
        let initiateFaceEntity = InitiateFaceEntity()
        initiateFaceEntity.email = email
        initiateFaceEntity.sub = sub
        initiateFaceEntity.usageType = usageType
        
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
                                
                                initiateFaceEntity.usage_pass = validateDeviceResponse.data.usage_pass
                                
                                // call initiateFace with usage service
                                FaceVerificationService.shared.initiateFace(initiateFaceEntity: initiateFaceEntity, properties: properties) {
                                    switch $0 {
                                    case .success(let initiateFaceResponse):
                                        // log success
                                        let loggerMessage = "Initiate with usage pass success : " + "Status Id - " + String(describing: initiateFaceResponse.data.statusId)
                                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                        
                                        self.statusId = initiateFaceResponse.data.statusId
                                        
                                        // construct object
                                        let authenticateFaceEntity = AuthenticateFaceEntity()
                                        authenticateFaceEntity.statusId = self.statusId
                                        
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
                                            case .success(let FaceResponse):
                                                // log success
                                                let loggerMessage = "Authenticate Face success : " + "Tracking Code - " + String(describing: FaceResponse.data.trackingCode + ", Sub - " + String(describing: FaceResponse.data.sub))
                                                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                                                
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
    
    public func verifyFace(photo: UIImage, statusId: String, properties: Dictionary<String, String>, callback: @escaping(Result<AuthenticateFaceResponseEntity>) -> Void) {
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
        let authenticateFaceEntity = AuthenticateFaceEntity()
        authenticateFaceEntity.statusId = self.statusId
        
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
            case .success(let patternResponse):
                // log success
                let loggerMessage = "Authenticate Face success : " + "Tracking Code - " + String(describing: patternResponse.data.trackingCode + ", Sub - " + String(describing: patternResponse.data.sub))
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return success callback
                DispatchQueue.main.async {
                    callback(Result.success(result: patternResponse))
                }
            }
        }
    }
}
