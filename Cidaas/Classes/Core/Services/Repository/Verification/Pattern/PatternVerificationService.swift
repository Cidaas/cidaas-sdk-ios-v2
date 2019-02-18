//
//  PatternVerificationService.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class PatternVerificationService {
    
    // shared instance
    public static var shared : PatternVerificationService = PatternVerificationService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // setup pattern
    public func setupPattern(accessToken: String, setupPatternEntity: SetupPatternEntity, properties : Dictionary<String, String>, callback: @escaping(Result<SetupPatternResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get access token
        
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "verification_api_version": "2",
            "access_token" : accessToken
        ]
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        setupPatternEntity.deviceInfo = deviceInfoEntity
        setupPatternEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(setupPatternEntity)
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
        urlString = baseURL + URLHelper.shared.getSetupPatternURL()
        
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
                            let setupPatternResponse = try decoder.decode(SetupPatternResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: setupPatternResponse))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_SETUP_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_SETUP_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_PATTERN_SETUP_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SETUP_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_SETUP_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SETUP_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SETUP_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SETUP_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_SETUP_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // scanned pattern
    public func scannedPattern(scannedPatternEntity: ScannedPatternEntity, properties : Dictionary<String, String>, callback: @escaping(Result<ScannedPatternResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get access token
        
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "verification_api_version": "2"
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        scannedPatternEntity.deviceInfo = deviceInfoEntity
        scannedPatternEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scannedPatternEntity)
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
        urlString = baseURL + URLHelper.shared.getScannedPatternURL()
        
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
                            let scannedPattern = try decoder.decode(ScannedPatternResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: scannedPattern))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_SCANNED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_SCANNED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_PATTERN_SCANNED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_SCANNED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_SCANNED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // enroll pattern
    public func enrollPattern(accessToken: String, enrollPatternEntity: EnrollPatternEntity, properties : Dictionary<String, String>, callback: @escaping(Result<EnrollPatternResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get access token
        
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "verification_api_version": "2",
            "access_token" : accessToken
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        enrollPatternEntity.deviceInfo = deviceInfoEntity
        enrollPatternEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(enrollPatternEntity)
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
        urlString = baseURL + URLHelper.shared.getEnrollPatternURL()
        
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
                            let enrollPatternResponseEntity = try decoder.decode(EnrollPatternResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: enrollPatternResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_ENROLLED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_PATTERN_ENROLLED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // initiate pattern
    public func initiatePattern(initiatePatternEntity: InitiatePatternEntity, properties : Dictionary<String, String>, callback: @escaping(Result<InitiatePatternResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get access token
        
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "verification_api_version": "2"
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        initiatePatternEntity.deviceInfo = deviceInfoEntity
        initiatePatternEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(initiatePatternEntity)
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
        urlString = baseURL + URLHelper.shared.getInitiatePatternURL()
        
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
                            let initiatePatternResponseEntity = try decoder.decode(InitiatePatternResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: initiatePatternResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_INITIATE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_INITIATE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_PATTERN_INITIATE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_INITIATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_INITIATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // Authenticate pattern
    public func authenticatePattern(authenticatePatternEntity: AuthenticatePatternEntity, properties : Dictionary<String, String>, callback: @escaping(Result<AuthenticatePatternResponseEntity>) -> Void) {
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
            "verification_api_version": "2"
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        authenticatePatternEntity.deviceInfo = deviceInfoEntity
        authenticatePatternEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(authenticatePatternEntity)
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
        urlString = baseURL + URLHelper.shared.getAuthenticatePatternURL()
        
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
                            let authenticatePatternResponseEntity = try decoder.decode(AuthenticatePatternResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: authenticatePatternResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_AUTHENTICATE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_PATTERN_AUTHENTICATE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_PATTERN_AUTHENTICATE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_AUTHENTICATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_AUTHENTICATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_AUTHENTICATE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_AUTHENTICATE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.PATTERN_AUTHENTICATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.PATTERN_AUTHENTICATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
}
