//
//  Cidaas.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class Cidaas {
    
    // shared instance
    public static var shared : Cidaas = Cidaas()
    
    // private local variablesa
    var requestId : String = ""
    var loginURLString : String = ""
    var redirectURLString : String = ""
    var fcmToken : String = ""
    var enableLog : Bool = false
    var enablePkce : Bool = true
    var deviceInfo : DeviceInfoModel
    var storage: TransactionStore
    var loginCallback : ((Result<LoginResponseEntity>) -> Void)?
    var customLoaderDelegate : CustomLoaderDelegate? = nil
    var loginDelegate : UIViewController? = nil
    var dbFileContent : String = ""
    var verificationType: String = ""
    var authenticationType: String = ""
    var timer = Timer()
    
    // static variables
    static var intermediate_verifiation_id: String = ""
    
    // log flag
    public var ENABLE_LOG : Bool {
        get {
            enableLog = DBHelper.shared.getEnableLog()
            return enableLog
        }
        set (enableLog) {
            self.enableLog = enableLog
            // save local
            DBHelper.shared.setEnableLog(enableLog: enableLog)
        }
    }
    
    // pkce flag
    public var ENABLE_PKCE : Bool {
        get {
            self.enablePkce = DBHelper.shared.getEnablePkce()
            return self.enablePkce
        }
        set (enablePkce) {
            self.enablePkce = enablePkce
            // save local
            DBHelper.shared.setEnablePkce(enablePkce: enablePkce)
        }
    }

    public var FCM_TOKEN : String {
        get {
            self.fcmToken = DBHelper.shared.getFCM()
            return self.fcmToken
        }
        
        set(fcmtoken) {
            DBHelper.shared.setFCM(fcmToken: fcmtoken)
            self.fcmToken = fcmtoken
        }
    }

// -------------------------------------------------------------------------------------------------- //
    
    // constructor
    init(storage : TransactionStore = TransactionStore.shared) {
        // set device info in local
        deviceInfo = DeviceInfoModel()
        deviceInfo.deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        deviceInfo.deviceMake = "Apple"
        let deviceHelper = DeviceHelper()
        deviceInfo.deviceModel = String(describing: deviceHelper.hardware())
        deviceInfo.deviceVersion = UIDevice.current.systemVersion
        DBHelper.shared.setDeviceInfo(deviceInfo: deviceInfo)
        
        // set storage in local
        self.storage = storage
        
        self.loginCallback = nil
        
        // set enable pkce in local
        self.ENABLE_PKCE = true
        
        // set enable log in local
        self.ENABLE_LOG = false
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // validate device
    public func validateDevice(userInfo: [AnyHashable: Any]) {
        if let intermediate_id = (userInfo as NSDictionary).value(forKey: "intermediate_verifiation_id") as! String? {
            Cidaas.intermediate_verifiation_id = intermediate_id
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get request id from plist
    // 1. Read properties from file
    // 2. Call request id from dictionary method
    // 3. Maintain logs based on flags
    public func getRequestId(callback: @escaping (Result<RequestIdResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            RequestIdController.shared.getRequestId(properties: savedProp!, callback: callback)
        }
            
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call get request id from dictionary
                            RequestIdController.shared.getRequestId(properties: properties, callback : callback)
                            break
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //

    // get tenant info from plist
    // 1. Read properties from file
    // 2. Call tenant info method
    // 3. Maintain logs based on flags
    public func getTenantInfo(callback: @escaping(Result<TenantInfoResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TenantController.shared.getTenantInfo(properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call get tenant info with properties
                            TenantController.shared.getTenantInfo(properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get client info from plist
    // 1. Read properties from file
    // 2. Call get client info method
    // 3. Maintain logs based on flags
    
    public func getClientInfo(requestId: String, callback: @escaping(Result<ClientInfoResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ClientController.shared.getClientInfo(requestId: requestId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call get client info with properties
                            ClientController.shared.getClientInfo(requestId: requestId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with credentials from plist
    // 1. Read properties from file
    // 2. Call loginWithCredentials method
    // 3. Maintain logs based on flags
    
    public func loginWithCredentials(requestId: String, loginEntity: LoginEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            LoginController.shared.loginWithCredentials(requestId: requestId, loginEntity: loginEntity, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithCredentials with properties
                            LoginController.shared.loginWithCredentials(requestId: requestId, loginEntity: loginEntity, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get consent details from plist
    // 1. Read properties from file
    // 2. Call getConsentDetails method
    // 3. Maintain logs based on flags
    
    public func getConsentDetails(consent_name: String, consent_version: Int16, track_id: String, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ConsentController.shared.getConsentDetails(consent_name: consent_name, consent_version: consent_version, track_id: track_id, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call getConsentDetails with properties
                            ConsentController.shared.getConsentDetails(consent_name: consent_name, consent_version: consent_version, track_id: track_id, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login after consent from plist
    // 1. Read properties from file
    // 2. Call loginAfterConsent method
    // 3. Maintain logs based on flags
    
    public func loginAfterConsent(sub: String, accepted: Bool, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ConsentController.shared.loginAfterConsent(sub: sub, accepted: true, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginAfterConsent with properties
                            ConsentController.shared.loginAfterConsent(sub: sub, accepted: true, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure email from plist
    // 1. Read properties from file
    // 2. Call configureEmail method
    // 3. Maintain logs based on flags
    
    public func configureEmail(sub: String, callback: @escaping(Result<SetupEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.configureEmail(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureEmail with properties
                            EmailVerificationController.shared.configureEmail(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // enroll email from plist
    // 1. Read properties from file
    // 2. Call enrollEmail method
    // 3. Maintain logs based on flags
    
    public func enrollEmail(code: String, callback: @escaping(Result<VerifyEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.configureEmail(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureEmail with properties
                            EmailVerificationController.shared.configureEmail(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify email from plist
    // 1. Read properties from file
    // 2. Call configureEmail method
    // 3. Maintain logs based on flags
    
    public func verifyEmail(code: String, callback: @escaping(Result<VerifyEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.configureEmail(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureEmail with properties
                            EmailVerificationController.shared.configureEmail(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with email from plist
    // 1. Read properties from file
    // 2. Call loginWithEmail method
    // 3. Maintain logs based on flags
    
    public func loginWithEmail(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<InitiateEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.loginWithEmail(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithEmail with properties
                            EmailVerificationController.shared.loginWithEmail(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure sms from plist
    // 1. Read properties from file
    // 2. Call configureSMS method
    // 3. Maintain logs based on flags
    
    public func configureSMS(sub: String, callback: @escaping(Result<SetupSMSResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.configureSMS(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureSMS with properties
                            SMSVerificationController.shared.configureSMS(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure SMS from plist
    // 1. Read properties from file
    // 2. Call configureSMS method
    // 3. Maintain logs based on flags
    
    public func enrollSMS(code: String, callback: @escaping(Result<VerifySMSResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.configureSMS(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureSMS with properties
                            SMSVerificationController.shared.configureSMS(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify SMS from plist
    // 1. Read properties from file
    // 2. Call verifySMS method
    // 3. Maintain logs based on flags
    
    public func verifySMS(code: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.verifySMS(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifySMS with properties
                            SMSVerificationController.shared.verifySMS(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with SMS from plist
    // 1. Read properties from file
    // 2. Call loginWithSMS method
    // 3. Maintain logs based on flags
    
    public func loginWithSMS(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<InitiateSMSResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.loginWithSMS(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithSMS with properties
                            SMSVerificationController.shared.loginWithSMS(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure IVR from plist
    // 1. Read properties from file
    // 2. Call configureIVR method
    // 3. Maintain logs based on flags
    
    public func configureIVR(sub: String, callback: @escaping(Result<SetupIVRResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.configureIVR(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureIVR with properties
                            IVRVerificationController.shared.configureIVR(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------------------------------- //
    
    // configure IVR from plist
    // 1. Read properties from file
    // 2. Call configureIVR method
    // 3. Maintain logs based on flags
    
    public func enrollIVR(code: String, callback: @escaping(Result<VerifyIVRResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.configureIVR(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureIVR with properties
                            IVRVerificationController.shared.configureIVR(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify IVR from plist
    // 1. Read properties from file
    // 2. Call verifyIVR method
    // 3. Maintain logs based on flags
    
    public func verifyIVR(code: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.verifyIVR(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifyIVR with properties
                            IVRVerificationController.shared.verifyIVR(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with IVR from plist
    // 1. Read properties from file
    // 2. Call loginWithIVR method
    // 3. Maintain logs based on flags
    
    public func loginWithIVR(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String = "", usageType: UsageTypes, callback: @escaping(Result<InitiateIVRResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.loginWithIVR(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithIVR with properties
                            IVRVerificationController.shared.loginWithIVR(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure Backupcode from plist
    // 1. Read properties from file
    // 2. Call configureBackupcode method
    // 3. Maintain logs based on flags
    
    public func configureBackupcode(sub: String, callback: @escaping(Result<SetupBackupcodeResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            BackupcodeVerificationController.shared.configureBackupcode(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureBackupcode with properties
                            BackupcodeVerificationController.shared.configureBackupcode(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with Backupcode from plist
    // 1. Read properties from file
    // 2. Call loginWithBackupcode method
    // 3. Maintain logs based on flags
    
    public func loginWithBackupcode(code: String, email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            BackupcodeVerificationController.shared.loginWithBackupcode(email: email, mobile: mobile, sub: sub, code: code, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithBackupcode with properties
                            BackupcodeVerificationController.shared.loginWithBackupcode(email: email, mobile: mobile, sub: sub, code: code, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure pattern from plist
    // 1. Read properties from file
    // 2. Call configurePatternRecognition method
    // 3. Maintain logs based on flags
    
    public func configurePatternRecognition(pattern: String, sub: String, callback: @escaping(Result<EnrollPatternResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PatternVerificationController.shared.configurePatternRecognition(pattern: pattern, sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configurePatternRecognition with properties
                            PatternVerificationController.shared.configurePatternRecognition(pattern: pattern, sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with pattern recognition from plist
    // 1. Read properties from file
    // 2. Call loginWithPatternRecognition method
    // 3. Maintain logs based on flags
    
    public func loginWithPatternRecognition(pattern: String, email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PatternVerificationController.shared.loginWithPatternRecognition(pattern: pattern, email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithPatternRecognition with properties
                            PatternVerificationController.shared.loginWithPatternRecognition(pattern: pattern, email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure TouchId from plist
    // 1. Read properties from file
    // 2. Call configureTouchId method
    // 3. Maintain logs based on flags
    
    public func configureTouchId(sub: String, callback: @escaping(Result<EnrollTouchResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TouchIdVerificationController.shared.configureTouchId(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureTouchIdRecognition with properties
                            TouchIdVerificationController.shared.configureTouchId(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with touch id from plist
    // 1. Read properties from file
    // 2. Call loginWithTouchId method
    // 3. Maintain logs based on flags
    
    public func loginWithTouchId(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TouchIdVerificationController.shared.loginWithTouchId(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithTouchId with properties
                            TouchIdVerificationController.shared.loginWithTouchId(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure Face from plist
    // 1. Read properties from file
    // 2. Call configureFace method
    // 3. Maintain logs based on flags
    
    public func configureFaceRecognition(sub: String, photo: UIImage, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            FaceVerificationController.shared.configureFace(sub: sub, photo:photo, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureFaceRecognition with properties
                            FaceVerificationController.shared.configureFace(sub: sub, photo: photo, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with face recognition from plist
    // 1. Read properties from file
    // 2. Call loginWithFaceRecognition method
    // 3. Maintain logs based on flags
    
    public func loginWithFaceRecognition(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, photo: UIImage, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            FaceVerificationController.shared.loginWithFace(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, photo: photo, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithFace with properties
                            FaceVerificationController.shared.loginWithFace(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, photo: photo, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure Voice from plist
    // 1. Read properties from file
    // 2. Call configureVoiceRecognition method
    // 3. Maintain logs based on flags
    
    public func configureVoiceRecognition(sub: String, voice: Data, callback: @escaping(Result<EnrollVoiceResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            VoiceVerificationController.shared.configureVoice(sub: sub, voice: voice, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureVoice with properties
                            VoiceVerificationController.shared.configureVoice(sub: sub, voice: voice, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with voice from plist
    // 1. Read properties from file
    // 2. Call loginWithVoiceRecognition method
    // 3. Maintain logs based on flags
    
    public func loginWithVoiceRecognition(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, voice: Data, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            VoiceVerificationController.shared.loginWithVoice(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, voice: voice, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithVoice with properties
                            VoiceVerificationController.shared.loginWithVoice(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, voice: voice, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure smart push from plist
    // 1. Read properties from file
    // 2. Call configureSmartPush method
    // 3. Maintain logs based on flags
    
    public func configureSmartPush(sub: String, callback: @escaping(Result<EnrollPushResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PushVerificationController.shared.configurePush(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configurePush with properties
                            PushVerificationController.shared.configurePush(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with push from plist
    // 1. Read properties from file
    // 2. Call loginWithSmartPush method
    // 3. Maintain logs based on flags
    
    public func loginWithSmartPush(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PushVerificationController.shared.loginWithPush(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithPush with properties
                            PushVerificationController.shared.loginWithPush(email: email, mobile: mobile, sub: sub, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure totp from plist
    // 1. Read properties from file
    // 2. Call configureTOTP method
    // 3. Maintain logs based on flags
    
    public func configureTOTP(sub: String, callback: @escaping(Result<EnrollTOTPResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TOTPVerificationController.shared.configureTOTP(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call configureTOTP with properties
                            TOTPVerificationController.shared.configureTOTP(sub: sub, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with totp from plist
    // 1. Read properties from file
    // 2. Call loginWithTOTP method
    // 3. Maintain logs based on flags
    
    public func loginWithTOTP(email: String = "", mobile: String = "", sub: String = "", trackId: String = "", requestId: String, usageType: UsageTypes, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TOTPVerificationController.shared.loginWithTOTP(email: email, sub: sub, mobile: mobile, trackId: trackId, requestId: requestId, usageType: usageType, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call loginWithTOTP with properties
                            TOTPVerificationController.shared.loginWithTOTP(email: email, sub: sub, mobile: mobile, trackId: trackId, requestId: requestId, usageType: usageType, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate account verification from plist
    // 1. Read properties from file
    // 2. Call initiateAccountVerification method
    // 3. Maintain logs based on flags
    
    public func initiateAccountVerification(requestId: String, sub: String, verificationMedium: VerificationMedium, callback: @escaping(Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.initiateAccountVerification(requestId: requestId, sub: sub, verificationMedium: verificationMedium.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call initiateAccountVerification with properties
                            AccountVerificationController.shared.initiateAccountVerification(requestId: requestId, sub: sub, verificationMedium: verificationMedium.rawValue, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify account from plist
    // 1. Read properties from file
    // 2. Call verifyAccount method
    // 3. Maintain logs based on flags
    
    public func verifyAccount(code: String, callback: @escaping(Result<VerifyAccountResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.verifyAccount(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifyAccount with properties
                            AccountVerificationController.shared.verifyAccount(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate reset password from plist
    // 1. Read properties from file
    // 2. Call initiateResetPassword method
    // 3. Maintain logs based on flags
    
    public func initiateResetPassword(requestId: String, email: String = "", mobile: String = "", resetMedium: ResetMedium, callback: @escaping(Result<InitiateResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.initiateResetPassword(requestId: requestId, email: email, mobile: mobile, resetMedium: resetMedium.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call initiateResetPassword with properties
                            ResetPasswordController.shared.initiateResetPassword(requestId: requestId, email: email, mobile: mobile, resetMedium: resetMedium.rawValue, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // Handle reset password from plist
    // 1. Read properties from file
    // 2. Call handleResetPassword method
    // 3. Maintain logs based on flags
    
    public func handleResetPassword(code: String, callback: @escaping(Result<HandleResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.handleResetPassword(code: code, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call handleResetPassword with properties
                            ResetPasswordController.shared.handleResetPassword(code: code, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // reset password from plist
    // 1. Read properties from file
    // 2. Call resetPassword method
    // 3. Maintain logs based on flags
    
    public func resetPassword(password: String, confirmPassword: String, callback: @escaping(Result<ResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.resetPassword(password: password, confirmPassword: confirmPassword, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call handleResetPassword with properties
                            ResetPasswordController.shared.resetPassword(password: password, confirmPassword: confirmPassword, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify pattern from plist
    // 1. Read properties from file
    // 2. Call verifyPattern method
    // 3. Maintain logs based on flags
    
    public func verifyPattern(pattern: String, statusId: String, callback: @escaping(Result<AuthenticatePatternResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PatternVerificationController.shared.verifyPattern(pattern: pattern, statusId: statusId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifyPattern with properties
                            PatternVerificationController.shared.verifyPattern(pattern: pattern, statusId: statusId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify Touch from plist
    // 1. Read properties from file
    // 2. Call verifyPattern method
    // 3. Maintain logs based on flags
    
    public func verifyTouchId(statusId: String, callback: @escaping(Result<AuthenticateTouchResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TouchIdVerificationController.shared.verifyTouchId(statusId: statusId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifyTouchId with properties
                            TouchIdVerificationController.shared.verifyTouchId(statusId: statusId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify Push from plist
    // 1. Read properties from file
    // 2. Call verifySmartPush method
    // 3. Maintain logs based on flags
    
    public func verifySmartPush(randomNumber: String, statusId: String, callback: @escaping(Result<AuthenticatePushResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PushVerificationController.shared.verifySmartPush(randomNumber: randomNumber, statusId: statusId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifySmartPush with properties
                            PushVerificationController.shared.verifySmartPush(randomNumber: randomNumber, statusId: statusId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify Face from plist
    // 1. Read properties from file
    // 2. Call verifyFace method
    // 3. Maintain logs based on flags
    
    public func verifyFace(photo: UIImage, statusId: String, callback: @escaping(Result<AuthenticateFaceResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            FaceVerificationController.shared.verifyFace(photo: photo, statusId: statusId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifyFace with properties
                            FaceVerificationController.shared.verifyFace(photo: photo, statusId: statusId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify Voice from plist
    // 1. Read properties from file
    // 2. Call verifyVoice method
    // 3. Maintain logs based on flags
    
    public func verifyVoice(voice: Data, statusId: String, callback: @escaping(Result<AuthenticateVoiceResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            VoiceVerificationController.shared.verifyVoice(voice: voice, statusId: statusId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call verifyVoice with properties
                            VoiceVerificationController.shared.verifyVoice(voice: voice, statusId: statusId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get user info from plist
    // 1. Read properties from file
    // 2. Call getUserInfo method
    // 3. Maintain logs based on flags
    
    public func getUserInfo(accessToken: String, callback: @escaping(Result<UserInfoEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            UsersController.shared.getUserInfo(access_token: accessToken, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call getUserInfo with properties
                            UsersController.shared.getUserInfo(access_token: accessToken, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get deduplication details from plist
    // 1. Read properties from file
    // 2. Call getDeduplicationDetails method
    // 3. Maintain logs based on flags
    
    public func getDeduplicationDetails(track_id: String, callback: @escaping(Result<DeduplicationDetailsResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            DeduplicationController.shared.getDeduplicationDetails(track_id: track_id, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call getDeduplicationDetails with properties
                            DeduplicationController.shared.getDeduplicationDetails(track_id: track_id, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }

// -------------------------------------------------------------------------------------------------- //
    
    // register deduplication from plist
    // 1. Read properties from file
    // 2. Call registerDeduplication method
    // 3. Maintain logs based on flags
    
    public func registerDeduplication(track_id: String, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            DeduplicationController.shared.registerDeduplication(track_id: track_id, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call registerDeduplication with properties
                            DeduplicationController.shared.registerDeduplication(track_id: track_id, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login deduplication from plist
    // 1. Read properties from file
    // 2. Call deduplicationDetails method
    // 3. Maintain logs based on flags
    
    public func deduplicationLogin(requestId: String, sub: String, password: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            DeduplicationController.shared.deduplicationLogin(requestId: requestId, sub: sub, password: password, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call deduplicationLogin with properties
                            DeduplicationController.shared.deduplicationLogin(requestId: requestId, sub: sub, password: password, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // change password from plist
    // 1. Read properties from file
    // 2. Call changePassword method
    // 3. Maintain logs based on flags
    
    public func changePassword(access_token: String, changePasswordEntity: ChangePasswordEntity, callback: @escaping(Result<ChangePasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ChangepasswordController.shared.changePassword(access_token: access_token, changePasswordEntity: changePasswordEntity, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call changePassword with properties
                            ChangepasswordController.shared.changePassword(access_token: access_token, changePasswordEntity: changePasswordEntity, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get registration fields from plist
    // 1. Read properties from file
    // 2. Call getRegistrationFields method
    // 3. Maintain logs based on flags
    
    public func getRegistrationFields(locale: String = "", requestId: String, callback: @escaping(Result<RegistrationFieldsResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            RegistrationController.shared.getRegistrationFields(locale: locale, requestId: requestId, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call getRegistrationFields with properties
                            RegistrationController.shared.getRegistrationFields(locale: locale, requestId: requestId, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // register user from plist
    // 1. Read properties from file
    // 2. Call registerUser method
    // 3. Maintain logs based on flags
    
    public func registerUser(requestId: String, registrationEntity: RegistrationEntity, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            RegistrationController.shared.registerUser(requestId: requestId, registrationEntity: registrationEntity, properties: savedProp!, callback: callback)
        }
        else {
            // read file properties
            FileHelper.shared.readProperties {
                switch $0 {
                case .failure(let error):
                    // log error
                    let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                    logw(loggerMessage, cname: "cidaas-sdk-error-log")
                    
                    // return failure callback
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                case .success(let properties):
                    // log success
                    let loggerMessage = "Read properties file success : " + "Properties Count - " + String(describing: properties.count)
                    logw(loggerMessage, cname: "cidaas-sdk-success-log")
                    
                    
                    self.saveProperties(properties: properties) {
                        switch $0 {
                        case .failure (let error):
                            // log error
                            let loggerMessage = "Saving properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                            logw(loggerMessage, cname: "cidaas-sdk-error-log")
                            
                            // return failure callback
                            DispatchQueue.main.async {
                                callback(Result.failure(error: error))
                            }
                            return
                        case .success( _):
                            // call registerUser with properties
                            RegistrationController.shared.registerUser(requestId: requestId, registrationEntity: registrationEntity, properties: properties, callback: callback)
                        }
                    }
                }
            }
        }
    }
    
// -------------------------------------------------------------------------------------------------- //

    // get TOTP frequently
    public func listenTOTP() {
        let qrcode = DBHelper.shared.getTOTPSecret()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer_response) in
            let totp_entity = TOTPVerificationController.shared.gettingTOTPCode(url: URL(string: qrcode)!)
            NotificationCenter.default.post(name: .totp, object: totp_entity)
        })
    }
    
    // cancel listen TOTP frequently
    public func cancelListenTOTP() {
        timer.invalidate()
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // save properties
    func saveProperties(properties: Dictionary<String, String>, callback:@escaping (Result<Bool>) -> Void) {
        var savedProperties = properties
        
        if self.enablePkce == false {
            // client secret null check
            if properties["ClientSecret"] == "" || properties["ClientSecret"] == nil {
                let error = WebAuthError.shared.propertyMissingException()
                // log error
                let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
            else {
                savedProperties["ClientSecret"] = properties["ClientSecret"]
            }
        }
            
        else {
            // create challenge and verifier
            let generator : OAuthChallengeGenerator = OAuthChallengeGenerator()
            savedProperties["Verifier"] = generator.verifier
            savedProperties["Challenge"] = generator.challenge
            savedProperties["Method"] = generator.method
        }
        savedProperties["AuthorizationURL"] = (properties["DomainURL"]!) + "/authz-srv/authz"
        savedProperties["TokenURL"] = (properties["DomainURL"]!) + "/token-srv/token"
        savedProperties["GrantType"] = "authorization_code"
        savedProperties["ResponseType"] = "code"
        savedProperties["UserInfoURL"] = (properties["DomainURL"]!) + "/users-srv/userinfo"
        
        // construct url (will be removed. only for testing)
        self.loginURLString = (savedProperties["AuthorizationURL"]!) + "?response_type=" + (savedProperties["ResponseType"]!)
        self.loginURLString = self.loginURLString + "&client_id=" + (savedProperties["ClientId"]!)
        self.loginURLString = self.loginURLString + "&viewtype=login&redirect_uri=" + (savedProperties["RedirectURL"]!)
        self.loginURLString = self.loginURLString + "&code_challenge=" + (savedProperties["Challenge"]!)
        self.loginURLString = self.loginURLString + "&code_challenge_method=" + (savedProperties["Method"]!)
        self.redirectURLString = (savedProperties["RedirectURL"]!)
        
        // save local
        DBHelper.shared.setPropertyFile(properties: savedProperties)
        
        DispatchQueue.main.async {
            callback(Result.success(result: true))
        }
    }
}

extension Notification.Name {
    static let totp = Notification.Name("TOTP")
}
