//
//  RequestIdService.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class RequestIdService {
    
    // shared instance
    public static var shared : RequestIdService = RequestIdService()
    
    // constructor
    public init() {
        
    }
    
    // get request id service
    public func getRequestId(properties : Dictionary<String, String>, callback: @escaping (Result<RequestIdResponseEntity>) -> Void) {
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
        var bodyParams = Dictionary<String, String>()
        bodyParams["nonce"] = "12345"
        bodyParams["redirect_uri"] = properties["RedirectURL"]
        bodyParams["client_id"] = properties["ClientId"]
        bodyParams["client_secret"] = properties["ClientSecret"]
        bodyParams["response_type"] = "code"
        bodyParams["scope"] = "openid email roles profile offline_access phone"
        bodyParams["code_challenge"] = properties["Challenge"]
        bodyParams["code_challenge_method"] = properties["Method"]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getRequestIdURL()
        
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
                            let requestIdEntity = try decoder.decode(RequestIdResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: requestIdEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_REQUEST_ID_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_REQUEST_ID_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_REQUEST_ID_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REQUEST_ID_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.REQUEST_ID_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure:
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REQUEST_ID_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REQUEST_ID_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.REQUEST_ID_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.REQUEST_ID_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
}
