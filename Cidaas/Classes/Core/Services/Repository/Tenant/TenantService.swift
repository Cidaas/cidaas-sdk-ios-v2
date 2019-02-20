//
//  TenantService.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class TenantService {
    
    // shared instance
    public static var shared : TenantService = TenantService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // get tenant info
    public func getTenantInfo(properties : Dictionary<String, String>, callback: @escaping(Result<TenantInfoResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getTenantInfoURL()
        
        // call service
        Alamofire.request(urlString, method:.get, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let tenantInfoEntity = try decoder.decode(TenantInfoResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: tenantInfoEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_TENANT_INFO_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_TENANT_INFO_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_TENANT_INFO_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.TENANT_INFO_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.TENANT_INFO_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure(let error):
                if error._domain == NSURLErrorDomain {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
                    return
                }
                if (response.data != nil) {
                    let jsonString = String(decoding: response.data!, as: UTF8.self)
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.TENANT_INFO_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.TENANT_INFO_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.TENANT_INFO_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.TENANT_INFO_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
}
