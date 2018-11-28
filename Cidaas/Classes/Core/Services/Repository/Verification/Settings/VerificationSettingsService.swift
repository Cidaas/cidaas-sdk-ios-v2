//
//  VerificationSettingsService.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class VerificationSettingsService {
    
    // shared instance
    public static var shared : VerificationSettingsService = VerificationSettingsService()
    
    // constructor
    public init() {
        
    }
    
    // get MFA List
    public func getMFAList(sub: String, userDeviceId: String, properties : Dictionary<String, String>, callback: @escaping(Result<MFAListResponseEntity>) -> Void) {
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
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        var user_device_id = userDeviceId
        
        // check userDeviceId
        if (user_device_id == "") {
            user_device_id = deviceInfoEntity.deviceId
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getMFAListURL(sub: sub, userDeviceId: user_device_id)
        
        
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
                            let mfaListResponseEntity = try decoder.decode(MFAListResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: mfaListResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_LIST_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_LIST_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_MFA_LIST_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_LIST_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_MFA_LIST_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.MFA_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_LIST_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_LIST_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.MFA_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
    
    // mfa continue service
    public func mfaContinue(mfaContinueEntity: MFAContinueEntity, properties : Dictionary<String, String>, callback: @escaping (Result<AuthzCodeEntity>) -> Void) {
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
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(mfaContinueEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
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
        urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: mfaContinueEntity.trackId)
        
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
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_CONTINUE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_CONTINUE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_MFA_CONTINUE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.MFA_CONTINUE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.MFA_CONTINUE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error: ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // passwordless continue service
    public func passwordlessContinue(mfaContinueEntity: MFAContinueEntity, properties : Dictionary<String, String>, callback: @escaping (Result<AuthzCodeEntity>) -> Void) {
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
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(mfaContinueEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
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
        urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
        
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
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_CONTINUE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_MFA_CONTINUE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_MFA_CONTINUE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.MFA_CONTINUE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.MFA_CONTINUE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.MFA_CONTINUE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error: ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // delete verification
    public func deleteVerification(userDeviceId: String, verificationType: String, properties : Dictionary<String, String>, callback: @escaping(Result<DeleteResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "deviceId": deviceInfoEntity.deviceId,
            "deviceMake": deviceInfoEntity.deviceMake,
            "deviceModel": deviceInfoEntity.deviceModel,
            "deviceVersion": deviceInfoEntity.deviceVersion
        ]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getDeleteVerificationURL(userDeviceId: userDeviceId, verificationType: verificationType)
        
        // call service
        Alamofire.request(urlString, method:.delete, parameters: nil, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let deleteResponseEntity = try decoder.decode(DeleteResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: deleteResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_DELETE_VERIFICATION_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_DELETE_VERIFICATION_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_DELETE_VERIFICATION_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_DELETE_VERIFICATION_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_DELETE_VERIFICATION_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.DELETE_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.DELETE_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
    
    // delete all verification by tenant
    public func deleteAllVerification(userDeviceId: String, properties : Dictionary<String, String>, callback: @escaping(Result<DeleteResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "deviceId": deviceInfoEntity.deviceId,
            "deviceMake": deviceInfoEntity.deviceMake,
            "deviceModel": deviceInfoEntity.deviceModel,
            "deviceVersion": deviceInfoEntity.deviceVersion
        ]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getDeleteAllVerificationURL(userDeviceId: userDeviceId)
        
        // call service
        Alamofire.request(urlString, method:.delete, parameters: nil, headers: headers).validate().responseString { response in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            // decode the json data to object
                            let deleteResponseEntity = try decoder.decode(DeleteResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: deleteResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_DELETE_VERIFICATION_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_DELETE_VERIFICATION_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_DELETE_VERIFICATION_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else if response.response?.statusCode == 204 {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_DELETE_VERIFICATION_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_DELETE_VERIFICATION_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.DELETE_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DELETE_VERIFICATION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.DELETE_VERIFICATION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                break
            }
        }
    }
}
