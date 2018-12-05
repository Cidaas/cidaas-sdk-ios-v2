//
//  SettingsController.swift
//  Cidaas
//
//  Created by ganesh on 27/11/18.
//

import Foundation

public class SettingsController {
    
    // shared instance
    public static var shared : SettingsController = SettingsController()
    
    // constructor
    public init() {
        
    }
    
    // get end points
    public func getEndpoints(properties: Dictionary<String, String>, callback: @escaping (Result<EndpointsResponseEntity>) -> Void) {
        
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
        
        // call getEndpoints service
        SettingsService.shared.getEndpoints(properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get endpoints service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Get endpoints service success : " + "Authz URL - " + serviceResponse.authorization_endpoint
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
    
    // update fcm
    public func updateFCMToken(sub: String, fcmId: String, properties: Dictionary<String, String>, callback: @escaping(Result<UpdateFCMTokenResponseEntity>) -> Void) {
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
        if (sub == "" || fcmId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub or fcmId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                break
            case .success(let tokenResponse):
                // call updateFCMToken
                SettingsService.shared.updateFCMToken(accessToken: tokenResponse.data.access_token, fcmId: fcmId, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Update FCM service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Update FCM service success : " + "Status code  - " + String(describing: serviceResponse.status)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: serviceResponse))
                        }
                    }
                }
                break
            }
        }
    }
    
    // get pending notification list
    public func getPendingNotification(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<PendingNotificationListResponseEntity>) -> Void) {
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
        if (sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                break
            case .success(let tokenResponse):
                // getting userDeviceId
                let userDeviceId = DBHelper.shared.getUserDeviceId(key: properties["DomainURL"] ?? "OAuthUserDeviceId")
                
                // call getPendingNotificationList
                SettingsService.shared.getPendingNotificationList(accessToken: tokenResponse.data.access_token, userDeviceId: userDeviceId, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Get pending notification service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Get pending notification service success : " + "Status code  - " + String(describing: serviceResponse.status)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: serviceResponse))
                        }
                    }
                }
                break
            }
        }
    }
    
    // deny notification request
    public func denyNotificationRequest(sub: String, statusId: String, rejectReason: String, properties: Dictionary<String, String>, callback: @escaping(Result<DenyNotificationResponseEntity>) -> Void) {
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
        if (sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                break
            case .success(let tokenResponse):
                
                // call denyNotificationRequest
                SettingsService.shared.denyNotificationRequest(accessToken: tokenResponse.data.access_token, statusId: statusId, rejectReason: rejectReason, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Deny notification service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Deny notification service success : " + "Status code  - " + String(describing: serviceResponse.status)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: serviceResponse))
                        }
                    }
                }
                break
            }
        }
    }
}
