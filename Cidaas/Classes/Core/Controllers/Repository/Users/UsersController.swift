//
//  UsersController.swift
//  Cidaas
//
//  Created by ganesh on 31/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class UsersController {
    
    // shared instance
    public static var shared : UsersController = UsersController()
    
    // constructor
    public init() {
        
    }
    
    // get user info
    public func getUserInfo(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<UserInfoEntity>) -> Void) {
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
         
                // call get user info service
                UsersService.shared.getUserInfo(accessToken: tokenResponse.data.access_token, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "User-Info service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let userInfoResponse):
                        // log success
                        let loggerMessage = "User-Info service success : " + "Email  - " + String(describing: userInfoResponse.email)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // assign base url
                        let baseURL = (properties["DomainURL"]) ?? ""
                        let currentTime = self.getCurrentMillis()
                        
                        // set profile picture if not set
                        if userInfoResponse.picture == "" {
                            userInfoResponse.picture = baseURL + "/profile/" + sub + "?v=" + String(describing: currentTime)
                        }
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: userInfoResponse))
                        }
                    }
                }
                
            }
        }
    }
    
    // get user info from access token
    public func getUserInfo(accessToken: String, properties: Dictionary<String, String>, callback: @escaping(Result<UserInfoEntity>) -> Void) {
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
        if (accessToken == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "accessToken must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call get user info service
        UsersService.shared.getUserInfo(accessToken: accessToken, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "User-Info service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let userInfoResponse):
                // log success
                let loggerMessage = "User-Info service success : " + "Email  - " + String(describing: userInfoResponse.email)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // assign base url
                let baseURL = (properties["DomainURL"]) ?? ""
                let currentTime = self.getCurrentMillis()
                
                // set profile picture if not set
                if userInfoResponse.picture == "" {
                    userInfoResponse.picture = baseURL + "/profile/" + userInfoResponse.sub + "?v=" + String(describing: currentTime)
                }
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: userInfoResponse))
                }
            }
        }
    }
    
    // upload image
    public func uploadImage(sub: String, photo: UIImage, properties: Dictionary<String, String>, callback: @escaping(Result<UploadImageResponseEntity>) -> Void) {
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
                
                // call upload image service
                UsersService.shared.uploadImage(accessToken: tokenResponse.data.access_token, photo: photo, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Upload image service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tenantInfoResponse):
                        // log success
                        let loggerMessage = "Upload image service success : " + "Uploaded  - " + String(describing: tenantInfoResponse.data)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: tenantInfoResponse))
                        }
                    }
                }
                
            }
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
