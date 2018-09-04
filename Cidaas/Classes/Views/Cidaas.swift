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
    
    // private local variables
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
        
        // read property from file
        self.readPropertyFile()
        
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // read property file
    public func readPropertyFile() {
        FileHelper.shared.readProperties {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Read properties file failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
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
                        return
                    case .success(let response):
                        // log success
                        let loggerMessage = "Saved Property status : \(response)"
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        break
                    }
                }
            }
        }
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get consent details from plist
    // 1. Read properties from file
    // 2. Call getConsentDetails method
    // 3. Maintain logs based on flags
    
    public func getConsentDetails(consent_name: String, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ConsentController.shared.getConsentDetails(consent_name: consent_name, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login after consent from plist
    // 1. Read properties from file
    // 2. Call loginAfterConsent method
    // 3. Maintain logs based on flags
    
    public func loginAfterConsent(consentEntity: ConsentEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ConsentController.shared.loginAfterConsent(consentEntity: consentEntity, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // enroll email from plist
    // 1. Read properties from file
    // 2. Call enrollEmail method
    // 3. Maintain logs based on flags
    
    public func enrollEmail(statusId: String, code: String, callback: @escaping(Result<VerifyEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.configureEmail(statusId: statusId, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify email from plist
    // 1. Read properties from file
    // 2. Call configureEmail method
    // 3. Maintain logs based on flags
    
    public func verifyEmail(statusId: String, code: String, callback: @escaping(Result<VerifyEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.configureEmail(statusId: statusId, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with email from plist
    // 1. Read properties from file
    // 2. Call loginWithEmail method
    // 3. Maintain logs based on flags
    
    public func loginWithEmail(passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<InitiateEmailResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            EmailVerificationController.shared.loginWithEmail(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure SMS from plist
    // 1. Read properties from file
    // 2. Call configureSMS method
    // 3. Maintain logs based on flags
    
    public func enrollSMS(statusId: String, code: String, callback: @escaping(Result<VerifySMSResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.configureSMS(statusId: statusId, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify SMS from plist
    // 1. Read properties from file
    // 2. Call verifySMS method
    // 3. Maintain logs based on flags
    
    public func verifySMS(statusId: String, code: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.verifySMS(statusId: statusId, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with SMS from plist
    // 1. Read properties from file
    // 2. Call loginWithSMS method
    // 3. Maintain logs based on flags
    
    public func loginWithSMS(passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<InitiateSMSResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            SMSVerificationController.shared.loginWithSMS(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
    // -------------------------------------------------------------------------------------------------- //
    
    // configure IVR from plist
    // 1. Read properties from file
    // 2. Call configureIVR method
    // 3. Maintain logs based on flags
    
    public func enrollIVR(statusId: String, code: String, callback: @escaping(Result<VerifyIVRResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.configureIVR(statusId: statusId, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify IVR from plist
    // 1. Read properties from file
    // 2. Call verifyIVR method
    // 3. Maintain logs based on flags
    
    public func verifyIVR(statusId: String, code: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.verifyIVR(statusId: statusId, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with IVR from plist
    // 1. Read properties from file
    // 2. Call loginWithIVR method
    // 3. Maintain logs based on flags
    
    public func loginWithIVR(passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<InitiateIVRResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            IVRVerificationController.shared.loginWithIVR(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with Backupcode from plist
    // 1. Read properties from file
    // 2. Call loginWithBackupcode method
    // 3. Maintain logs based on flags
    
    public func loginWithBackupcode(code: String, passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            BackupcodeVerificationController.shared.loginWithBackupcode(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, code: code, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with pattern recognition from plist
    // 1. Read properties from file
    // 2. Call loginWithPatternRecognition method
    // 3. Maintain logs based on flags
    
    public func loginWithPatternRecognition(pattern: String, passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PatternVerificationController.shared.loginWithPatternRecognition(pattern: pattern, email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with touch id from plist
    // 1. Read properties from file
    // 2. Call loginWithTouchId method
    // 3. Maintain logs based on flags
    
    public func loginWithTouchId(passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TouchIdVerificationController.shared.loginWithTouchId(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure Face from plist
    // 1. Read properties from file
    // 2. Call configureFace method
    // 3. Maintain logs based on flags
    
    public func configureFaceRecognition(photo: UIImage, sub: String, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            FaceVerificationController.shared.configureFace(sub: sub, photo:photo, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with face recognition from plist
    // 1. Read properties from file
    // 2. Call loginWithFaceRecognition method
    // 3. Maintain logs based on flags
    
    public func loginWithFaceRecognition(photo: UIImage, passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            FaceVerificationController.shared.loginWithFace(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, photo: photo, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // configure Voice from plist
    // 1. Read properties from file
    // 2. Call configureVoiceRecognition method
    // 3. Maintain logs based on flags
    
    public func configureVoiceRecognition(voice: Data, sub: String, callback: @escaping(Result<EnrollVoiceResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            VoiceVerificationController.shared.configureVoice(sub: sub, voice: voice, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with voice from plist
    // 1. Read properties from file
    // 2. Call loginWithVoiceRecognition method
    // 3. Maintain logs based on flags
    
    public func loginWithVoiceRecognition(voice: Data, passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            VoiceVerificationController.shared.loginWithVoice(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, voice: voice, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with push from plist
    // 1. Read properties from file
    // 2. Call loginWithSmartPush method
    // 3. Maintain logs based on flags
    
    public func loginWithSmartPush(passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            PushVerificationController.shared.loginWithPush(email: passwordlessEntity.email, mobile: passwordlessEntity.mobile, sub: passwordlessEntity.sub, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login with totp from plist
    // 1. Read properties from file
    // 2. Call loginWithTOTP method
    // 3. Maintain logs based on flags
    
    public func loginWithTOTP(passwordlessEntity: PasswordlessEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            TOTPVerificationController.shared.loginWithTOTP(email: passwordlessEntity.email, sub: passwordlessEntity.sub, mobile: passwordlessEntity.mobile, trackId: passwordlessEntity.trackId, requestId: passwordlessEntity.requestId, usageType: passwordlessEntity.usageType, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate email verification from plist
    // 1. Read properties from file
    // 2. Call initiateEmailVerification method
    // 3. Maintain logs based on flags
    
    public func initiateEmailVerification(requestId: String, sub: String, callback: @escaping(Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.initiateAccountVerification(requestId: requestId, sub: sub, verificationMedium: VerificationMedium.EMAIL.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate sms verification from plist
    // 1. Read properties from file
    // 2. Call initiateSMSVerification method
    // 3. Maintain logs based on flags
    
    public func initiateSMSVerification(requestId: String, sub: String, callback: @escaping(Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.initiateAccountVerification(requestId: requestId, sub: sub, verificationMedium: VerificationMedium.SMS.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate ivr verification from plist
    // 1. Read properties from file
    // 2. Call initiateIVRVerification method
    // 3. Maintain logs based on flags
    
    public func initiateIVRVerification(requestId: String, sub: String, callback: @escaping(Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.initiateAccountVerification(requestId: requestId, sub: sub, verificationMedium: VerificationMedium.IVR.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // verify account from plist
    // 1. Read properties from file
    // 2. Call verifyAccount method
    // 3. Maintain logs based on flags
    
    public func verifyAccount(accvid: String, code: String, callback: @escaping(Result<VerifyAccountResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.verifyAccount(accvid: accvid, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate reset password from plist
    // 1. Read properties from file
    // 2. Call initiateResetPassword method
    // 3. Maintain logs based on flags
    
    public func initiateResetPassword(requestId: String, email: String, callback: @escaping(Result<InitiateResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.initiateResetPassword(requestId: requestId, email: email, mobile: "", resetMedium: ResetMedium.EMAIL.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // initiate reset password from plist
    // 1. Read properties from file
    // 2. Call initiateResetPassword method
    // 3. Maintain logs based on flags
    
    public func initiateResetPassword(requestId: String, mobile: String, callback: @escaping(Result<InitiateResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.initiateResetPassword(requestId: requestId, email: "", mobile: mobile, resetMedium: ResetMedium.SMS.rawValue, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // Handle reset password from plist
    // 1. Read properties from file
    // 2. Call handleResetPassword method
    // 3. Maintain logs based on flags
    
    public func handleResetPassword(rprq: String, code: String, callback: @escaping(Result<HandleResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.handleResetPassword(rprq: rprq, code: code, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // reset password from plist
    // 1. Read properties from file
    // 2. Call resetPassword method
    // 3. Maintain logs based on flags
    
    public func resetPassword(rprq: String, exchangeId: String, password: String, confirmPassword: String, callback: @escaping(Result<ResetPasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ResetPasswordController.shared.resetPassword(rprq: rprq, exchangeId: exchangeId, password: password, confirmPassword: confirmPassword, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get user info from plist
    // 1. Read properties from file
    // 2. Call getUserInfo method
    // 3. Maintain logs based on flags
    
    public func getUserInfo(sub: String, callback: @escaping(Result<UserInfoEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            UsersController.shared.getUserInfo(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get access token from sub
    // 1. Call getAccessToken method
    
    public func getAccessToken(sub: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        AccessTokenController.shared.getAccessToken(sub: sub, callback: callback)
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get access token from refresh token
    // 1. Call getAccessToken method
    
    public func getAccessToken(refreshToken: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        AccessTokenController.shared.getAccessToken(refreshToken: refreshToken, callback: callback)
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }

// -------------------------------------------------------------------------------------------------- //
    
    // register deduplication from plist
    // 1. Read properties from file
    // 2. Call registerUser method
    // 3. Maintain logs based on flags
    
    public func registerUser(track_id: String, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            DeduplicationController.shared.registerDeduplication(track_id: track_id, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // login deduplication from plist
    // 1. Read properties from file
    // 2. Call deduplicationDetails method
    // 3. Maintain logs based on flags
    
    public func loginWithDeduplication(requestId: String, sub: String, password: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            DeduplicationController.shared.deduplicationLogin(requestId: requestId, sub: sub, password: password, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // change password from plist
    // 1. Read properties from file
    // 2. Call changePassword method
    // 3. Maintain logs based on flags
    
    public func changePassword(sub: String, changePasswordEntity: ChangePasswordEntity, callback: @escaping(Result<ChangePasswordResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            ChangepasswordController.shared.changePassword(sub: sub, changePasswordEntity: changePasswordEntity, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
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
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get user Activity from plist
    // 1. Read properties from file
    // 2. Call getUserActivity method
    // 3. Maintain logs based on flags
    
    public func getUserActivity(userActivity: UserActivityEntity, callback: @escaping(Result<UserActivityResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            UserActivityController.shared.getUserActivity(userActivity: userActivity, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // update user from plist
    // 1. Read properties from file
    // 2. Call updateUser method
    // 3. Maintain logs based on flags
    
    public func updateUser(sub: String, registrationEntity: RegistrationEntity, callback: @escaping(Result<UpdateUserResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            RegistrationController.shared.updateUser(sub: sub, registrationEntity: registrationEntity, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // upload image from plist
    // 1. Read properties from file
    // 2. Call uploadImage method
    // 3. Maintain logs based on flags
    
    public func uploadImage(sub: String, photo: UIImage, callback: @escaping(Result<UploadImageResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            UsersController.shared.uploadImage(sub: sub, photo: photo, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // link account from plist
    // 1. Read properties from file
    // 2. Call linkAccount method
    // 3. Maintain logs based on flags
    
    public func linkAccount(master_sub: String, sub_to_link: String, callback: @escaping(Result<LinkAccountResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            LinkUnlinkController.shared.linkAccount(master_sub: master_sub, sub_to_link: sub_to_link, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get linked users from plist
    // 1. Read properties from file
    // 2. Call getLinkedUsers method
    // 3. Maintain logs based on flags
    
    public func getLinkedUsers(sub: String, callback: @escaping(Result<LinkedUserListResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            LinkUnlinkController.shared.getLinkedUsers(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // unlink account from plist
    // 1. Read properties from file
    // 2. Call unlinkAccount method
    // 3. Maintain logs based on flags
    
    public func unlinkAccount(identityId: String, sub: String, callback: @escaping(Result<LinkAccountResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            LinkUnlinkController.shared.unlinkAccount(identityId: identityId, sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get mfa list from plist
    // 1. Read properties from file
    // 2. Call getMFAList method
    // 3. Maintain logs based on flags
    
    public func getMFAList(sub: String, callback: @escaping(Result<MFAListResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            VerificationSettingsController.shared.getMFAList(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //
    
    // get account verification list from plist
    // 1. Read properties from file
    // 2. Call getMFAList method
    // 3. Maintain logs based on flags
    
    public func getAccountVerificationList(sub: String, callback: @escaping(Result<AccountVerificationListResponseEntity>) -> Void) {
        
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            AccountVerificationController.shared.getAccountVerificationList(sub: sub, properties: savedProp!, callback: callback)
        }
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
    
// -------------------------------------------------------------------------------------------------- //

    // get TOTP frequently
    public func listenTOTP(sub: String) {
        let qrcode = DBHelper.shared.getTOTPSecret(key: sub)
        
        if (qrcode == "") {
            // TODO handle error message
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer_response) in
            let totp_entity = TOTPVerificationController.shared.gettingTOTPCode(url: URL(string: qrcode)!)
            NotificationCenter.default.post(name: .totp, object: totp_entity)
        })
    }
    
    // cancel listen TOTP
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