//
//  AccessTokenController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AccessTokenController {
    
    // shared instance
    public static var shared : AccessTokenController = AccessTokenController()
    
    // constructor
    public init() {
        
    }
    
    // get access token by code
    public func getAccessToken(code: String, callback: @escaping (Result<LoginResponseEntity>) -> Void) {
        
        // log info
        let loggerMessage = "Get Access token from code controller : " + "Incoming Data - " + code
        logw(loggerMessage, cname: "cidaas-sdk-info-log")
        
        let properties = DBHelper.shared.getPropertyFile()
        if (properties == nil) {
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            }
            return
        }
        
        // call access token service
        AccessTokenService.shared.getAccessToken(code: code, properties: properties!) {
            switch $0 {
            case .failure(let error):
                
                // log error
                let loggerMessage = "Access token from code service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let accessTokenEntity):
                
                // log success
                let loggerMessage = "Access token from code service success : " + "Access Token - " + accessTokenEntity.access_token + ", Refresh Token - " + accessTokenEntity.refresh_token + ", Expires In Time - " + String(describing: accessTokenEntity.expires_in)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // assign to access token model
                EntityToModelConverter.shared.accessTokenEntityToAccessTokenModel(accessTokenEntity: accessTokenEntity, callback: { _ in
                    
                    self.saveAccessToken(accessTokenEntity: accessTokenEntity, callback: callback)
                    
                })
            }
        }
    }
    
    
    // get access token by sub
    public func getAccessToken(sub: String, callback: @escaping (Result<LoginResponseEntity>) -> Void) {
        
        // getting current seconds
        let milliseconds = Date().timeIntervalSince1970
        let seconds = Int64(milliseconds)
        
        let accessTokenModel = DBHelper.shared.getAccessToken(key: sub)
        let expires = accessTokenModel.expires_in
        let secs: Int64 = Int64(accessTokenModel.seconds)
        let expires_in = expires + secs - 10
        
        if expires_in > seconds {
            
            if String(seconds).count < 10 {
                self.getAccessToken(refreshToken: accessTokenModel.refresh_token, callback: callback)
                return
            }
            
            EntityToModelConverter.shared.accessTokenModelToAccessTokenEntity(accessTokenModel: accessTokenModel) { (accessTokenEntity) in
                // return success callback
                let response = LoginResponseEntity()
                response.success = true
                response.status = 200
                response.data = accessTokenEntity
                
                DispatchQueue.main.async {
                    callback(Result.success(result: response))
                }
                return
            }
        }
            
        else {
            self.getAccessToken(refreshToken: accessTokenModel.refresh_token, callback: callback)
        }
    }
    
    
    // get access token by refresh token
    public func getAccessToken(refreshToken: String, callback: @escaping (Result<LoginResponseEntity>) -> Void) {
        
        let properties = DBHelper.shared.getPropertyFile()
        if (properties == nil) {
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            }
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "salt,key",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        
        var item: CFTypeRef?
        var salt: String = ""
        var key: String = ""
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any], let saltKey = existingItem[kSecValueData as String] as? Data,
               let saltKeyDecoded = String(data: saltKey, encoding: .utf8) {
                salt = saltKeyDecoded.components(separatedBy: ",")[0]
                key = saltKeyDecoded.components(separatedBy: ",")[1]
                
            }
            
        }

        var decryptedRefreshToken = ""
        
        do {
            decryptedRefreshToken = try refreshToken.aesDecrypt(key: key, iv: salt)
        } catch {
            // to handle crashes
            decryptedRefreshToken = refreshToken
        }
        
        // call access token from refresh token service
        AccessTokenService.shared.getAccessToken(refreshToken: decryptedRefreshToken, properties: properties!) {
            switch $0 {
            case .failure(let error):
                
                // log error
                let loggerMessage = "Access token from refresh token service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let accessTokenEntity):
                
                // log success
                let loggerMessage = "Access token from refresh token service success : " + "Access Token - " + accessTokenEntity.access_token + ", Refresh Token - " + accessTokenEntity.refresh_token + ", Expires In Time - " + String(describing: accessTokenEntity.expires_in)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // assign to access token model
                EntityToModelConverter.shared.accessTokenEntityToAccessTokenModel(accessTokenEntity: accessTokenEntity, callback: { _ in
                    
                    self.saveAccessToken(accessTokenEntity: accessTokenEntity, callback: callback)
                    
                })
            }
        }
        
    }
    
    // get access token by social token
    public func getAccessToken(requestId: String, socialToken: String, provider: String, viewType: String, callback: @escaping (Result<LoginResponseEntity>) -> Void) {
        
        let properties = DBHelper.shared.getPropertyFile()
        if (properties == nil) {
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            }
            return
        }
        
        // call code from social token service
        AccessTokenService.shared.getAccessToken(requestId: requestId, socialToken: socialToken, provider: provider, viewType: viewType, properties: properties!) {
            switch $0 {
            case .failure(let error):
                
                // log error
                let loggerMessage = "Access token from social service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let socialEntity):
                
                // log success
                let loggerMessage = "Access token from social service success : " + "Code - " + socialEntity.code
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                self.getAccessToken(code: socialEntity.code, callback: callback)
                
            }
        }
        
    }
    
    
    // save access token in local db
    public func saveAccessToken(accessTokenModel : AccessTokenModel = AccessTokenModel.shared, accessTokenEntity : AccessTokenEntity, callback: @escaping (Result<LoginResponseEntity>) -> Void) {
        
        // set current time
        let milliseconds = Date().timeIntervalSince1970
        let seconds = Int64(milliseconds)
        accessTokenModel.seconds = seconds
        
        // save access token in local db
        DBHelper.shared.setAccessToken(accessTokenModel: accessTokenModel)
        
        // return success callback
        let response = LoginResponseEntity()
        response.success = true
        response.status = 200
        response.data = accessTokenEntity
        
        DispatchQueue.main.async {
            callback(Result.success(result: response))
        }
    }
}
