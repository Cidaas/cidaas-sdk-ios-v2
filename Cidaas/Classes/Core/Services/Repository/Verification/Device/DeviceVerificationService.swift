//
//  DeviceVerificationService.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class DeviceVerificationService {

    // shared instance
    public static var shared : DeviceVerificationService = DeviceVerificationService()
    
    // constructor
    public init() {
        
    }
    
    // validate device
    public func validateDevice(validateDeviceEntity: ValidateDeviceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<ValidateDeviceResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get access token
        
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
        ]
        
        validateDeviceEntity.deviceInfo = deviceInfoEntity
        validateDeviceEntity.access_verifier = properties["Verifier"] ?? ""
        
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(validateDeviceEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
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
        urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
        
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
                            let validateDevice = try decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: validateDevice))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VALIDATE_DEVICE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VALIDATE_DEVICE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_VALIDATE_DEVICE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VALIDATE_DEVICE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VALIDATE_DEVICE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VALIDATE_DEVICE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VALIDATE_DEVICE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VALIDATE_DEVICE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VALIDATE_DEVICE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  response.value ?? response.error?.localizedDescription ?? "")))
                }
                break
            }
        }
    }
}
