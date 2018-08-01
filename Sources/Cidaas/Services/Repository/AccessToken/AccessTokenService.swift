//
//  AccessTokenService.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class AccessTokenService {
    
    // shared instance
    public static var shared : AccessTokenService = AccessTokenService()
    
    // constructor
    public init() {
        
    }
    
    // get access token by code
    public func getAccessToken(code : String, properties : Dictionary<String, String>, callback: @escaping (Result<AccessTokenEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders;
        var urlString : String;
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "user-agent": "cidaas-ios",
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["grant_type"] = properties["GrantType"]
        bodyParams["code"] = code
        bodyParams["redirect_uri"] = properties["RedirectURL"]
        bodyParams["client_id"] = properties["ClientId"]
        bodyParams["code_verifier"] = properties["Verifier"]
        
        // assign token url
        urlString = (properties["TokenURL"]) ?? ""
        
        if urlString == "" {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        if (urlString == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // call service
        Alamofire.request(urlString, method: .post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .failure:
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ACCESSTOKEN_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.ACCESS_TOKEN_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let accessTokenEntity = try decoder.decode(AccessTokenEntity.self, from: data)
                            // return success
                            callback(Result.success(result: accessTokenEntity))
                        }
                        catch {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                            return
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ACCESSTOKEN_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.ACCESS_TOKEN_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ACCESSTOKEN_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.ACCESS_TOKEN_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
            }
        }
    }
    
    // get access token by refresh token
    public func getAccessToken(refreshToken : String, properties : Dictionary<String, String>, callback: @escaping (Result<AccessTokenEntity>) -> Void) {
        
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "user-agent": "cidaas-ios",
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion,
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["grant_type"] = properties["refresh_token"]
        bodyParams["refresh_token"] = refreshToken
        bodyParams["redirect_uri"] = properties["RedirectURL"]
        bodyParams["client_id"] = properties["ClientId"]
        
        // assign token url
        urlString = (properties["TokenURL"]) ?? ""
        
        // call service
        Alamofire.request(urlString, method: .post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .failure:
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REFRESH_TOKEN_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.REFRESH_TOKEN_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let accessTokenEntity = try decoder.decode(AccessTokenEntity.self, from: data)
                            // return success
                            callback(Result.success(result: accessTokenEntity))
                        }
                        catch {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                            return
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REFRESH_TOKEN_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.REFRESH_TOKEN_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REFRESH_TOKEN_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.REFRESH_TOKEN_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
            }
        }
    }
}
