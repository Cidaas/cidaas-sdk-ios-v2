//
//  LoginService.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class LoginService {
    
    // shared instance
    public static var shared : LoginService = LoginService()
    
    // constructor
    public init() {
        
    }
    
    // login with credentials service
    public func loginWithCredentials(requestId: String, loginEntity: LoginEntity, properties : Dictionary<String, String>, callback: @escaping (Result<AuthzCodeEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(loginEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
            
            bodyParams["requestId"] = requestId
        }
        catch(_) {
            callback(Result.failure(error: WebAuthError.shared.conversionException()))
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getLoginWithCredentialsURL()
        
        // call service
        Alamofire.request(urlString, method: .post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let authzCodeEntity = try decoder.decode(AuthzCodeEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: authzCodeEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_LOGIN_WITH_CREDENTIAL_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_LOGIN_WITH_CREDENTIAL_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_LOGIN_WITH_CREDENTIAL_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure:
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(LoginErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity.error)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error: response.value ?? response.error?.localizedDescription ?? "")))
                }
                break
            }
        }
    }
}
