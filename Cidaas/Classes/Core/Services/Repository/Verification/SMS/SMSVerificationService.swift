//
//  SMSVerificationService.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class SMSVerificationService {
    
    // shared instance
    public static var shared : SMSVerificationService = SMSVerificationService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // setup SMS
    public func setupSMS(access_token: String, properties : Dictionary<String, String>, callback: @escaping(Result<SetupSMSResponseEntity>) -> Void) {
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
            "access_token": access_token
        ]
        
        // construct body params
        var dict = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(deviceInfoEntity)
            dict = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(Result.failure(error: WebAuthError.shared.conversionException()))
            return
        }
        
        var bodyParams = Dictionary<String, Any>()
        bodyParams["deviceInfo"] = dict
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getSetupSMSURL()
        
        // call service
        Alamofire.request(urlString, method:.post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let setupSMSResponseEntity = try decoder.decode(SetupSMSResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: setupSMSResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_SETUP_SMS_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_SETUP_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_SETUP_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_SETUP_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_SETUP_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.SETUP_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.SETUP_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.SETUP_SMS_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.SETUP_SMS_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.SETUP_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.SETUP_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
    
    // enroll SMS
    public func enrollSMS(access_token: String, enrollSMSEntity: EnrollSMSEntity, properties : Dictionary<String, String>, callback: @escaping(Result<VerifySMSResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct object
        enrollSMSEntity.deviceInfo = deviceInfoEntity
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(enrollSMSEntity)
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
        urlString = baseURL + URLHelper.shared.getEnrollSMSURL()
        
        // call service
        Alamofire.request(urlString, method:.post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let enrollSMSResponseEntity = try decoder.decode(VerifySMSResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: enrollSMSResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_ENROLL_SMS_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_ENROLL_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_ENROLL_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_ENROLL_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_ENROLL_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ENROLL_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.ENROLL_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ENROLL_SMS_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ENROLL_SMS_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ENROLL_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.ENROLL_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
    
    // initiate SMS
    public func initiateSMS(initiateSMSEntity: InitiateSMSEntity, properties : Dictionary<String, String>, callback: @escaping(Result<InitiateSMSResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        initiateSMSEntity.deviceInfo = deviceInfoEntity
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(initiateSMSEntity)
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
        urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
        
        // call service
        Alamofire.request(urlString, method:.post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let initiateSMSResponseEntity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: initiateSMSResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_INITIATE_SMS_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_INITIATE_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_INITIATE_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_INITIATE_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_INITIATE_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.INITIATE_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.INITIATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.INITIATE_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
    
    // authenticate SMS
    public func authenticateSMS(authenticateSMSEntity: AuthenticateSMSEntity, properties : Dictionary<String, String>, callback: @escaping(Result<VerifySMSResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        authenticateSMSEntity.deviceInfo = deviceInfoEntity
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1
        ]
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(authenticateSMSEntity)
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
        urlString = baseURL + URLHelper.shared.getAuthenticateSMSURL()
        
        // call service
        Alamofire.request(urlString, method:.post, parameters: bodyParams, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let authenticateSMSResponseEntity = try decoder.decode(VerifySMSResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: authenticateSMSResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_AUTHENTICATE_SMS_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_AUTHENTICATE_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_AUTHENTICATE_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_AUTHENTICATE_SMS_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_AUTHENTICATE_SMS_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.AUTHENTICATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.AUTHENTICATE_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.AUTHENTICATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.AUTHENTICATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.AUTHENTICATE_SMS_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.AUTHENTICATE_SMS_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
}
