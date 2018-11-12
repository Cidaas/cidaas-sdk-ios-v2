//
//  ChangePasswordService.swift
//  Cidaas
//
//  Created by ganesh on 01/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class ChangePasswordService {
    
    // shared instance
    public static var shared : ChangePasswordService = ChangePasswordService()
    
    // constructor
    public init() {
        
    }
    
    // change password
    public func changePassword(access_token: String, identityId: String, changePasswordEntity : ChangePasswordEntity, properties : Dictionary<String, String>, callback: @escaping (Result<ChangePasswordResponseEntity>) -> Void) {
        
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "access_token": access_token,
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(changePasswordEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            
            bodyParams["identityId"] = identityId
        }
        catch(_) {
            callback(Result.failure(error: WebAuthError.shared.conversionException()))
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if baseURL == "" {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getChangePasswordURL()
        
        Alamofire.request(urlString, method: .post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .failure:
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.CHANGE_PASSWORD_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.CHANGE_PASSWORD_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.CHANGE_PASSWORD_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.CHANGE_PASSWORD_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let userInfoEntity = try decoder.decode(ChangePasswordResponseEntity.self, from: data)
                            // return success
                            callback(Result.success(result: userInfoEntity))
                        }
                        catch {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
                            return
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.CHANGE_PASSWORD_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.CHANGE_PASSWORD_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.CHANGE_PASSWORD_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.CHANGE_PASSWORD_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    break
                }
            }
        }
    }
}
