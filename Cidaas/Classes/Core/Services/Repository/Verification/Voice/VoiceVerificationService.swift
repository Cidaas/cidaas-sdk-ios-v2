//
//  VoiceVerificationService.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

import Alamofire

public class VoiceVerificationService {
    
    // shared instance
    public static var shared : VoiceVerificationService = VoiceVerificationService()
    
    // constructor
    public init() {
        
    }
    
    // setup voice
    public func setupVoice(accessToken: String, setupVoiceEntity: SetupVoiceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<SetupVoiceResponseEntity>) -> Void) {
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
            "verification_api_version" : "2",
            "access_token" : accessToken
        ]
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        setupVoiceEntity.deviceInfo = deviceInfoEntity
        setupVoiceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(setupVoiceEntity)
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
        urlString = baseURL + URLHelper.shared.getSetupVoiceURL()
        
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
                            let setupVoiceResponse = try decoder.decode(SetupVoiceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: setupVoiceResponse))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_SETUP_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_SETUP_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_VOICE_SETUP_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_SETUP_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_SETUP_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // scanned voice
    public func scannedVoice(scannedVoiceEntity: ScannedVoiceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<ScannedVoiceResponseEntity>) -> Void) {
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
            "verification_api_version" : "2"
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        scannedVoiceEntity.deviceInfo = deviceInfoEntity
        scannedVoiceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scannedVoiceEntity)
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
        urlString = baseURL + URLHelper.shared.getScannedVoiceURL()
        
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
                            let scannedVoice = try decoder.decode(ScannedVoiceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: scannedVoice))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_SCANNED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_SCANNED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_VOICE_SCANNED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_SCANNED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_SCANNED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // enroll voice
    public func enrollVoice(accessToken: String, voice: Data, enrollVoiceEntity: EnrollVoiceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<EnrollVoiceResponseEntity>) -> Void) {
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
            "verification_api_version" : "2",
            "access_token" : accessToken
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        enrollVoiceEntity.deviceInfo = deviceInfoEntity
        enrollVoiceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["statusId"] = enrollVoiceEntity.statusId
        bodyParams["userDeviceId"] = enrollVoiceEntity.userDeviceId
        bodyParams["pushNotificationId"] = deviceInfoEntity.pushNotificationId
        bodyParams["deviceMake"] = deviceInfoEntity.deviceMake
        bodyParams["deviceModel"] = deviceInfoEntity.deviceModel
        bodyParams["deviceId"] = deviceInfoEntity.deviceId
        bodyParams["client_id"] = enrollVoiceEntity.client_id
        bodyParams["usage_pass"] = enrollVoiceEntity.usage_pass
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getEnrollVoiceURL()
        
        // call service
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        // call service
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in bodyParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if enrollVoiceEntity.usage_pass != "" {
                    multipartFormData.append(voice, withName: "voice", fileName: "voice.wav", mimeType: "audio/mpeg")
                }
                enrolledURL.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
                
        }, with: enrolledURL,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if response.response?.statusCode == 200 {
                        if let jsonString = response.result.value {
                            let decoder = JSONDecoder()
                            do {
                                let data = jsonString.data(using: .utf8)!
                                // decode the json data to object
                                let enrollVoiceResponseEntity = try decoder.decode(EnrollVoiceResponseEntity.self, from: data)
                                
                                // return success
                                callback(Result.success(result: enrollVoiceResponseEntity))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_ENROLLED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_VOICE_ENROLLED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                    else {
                        if let jsonString = response.result.value {
                            let decoder = JSONDecoder()
                            do {
                                let data = jsonString.data(using: .utf8)!
                                // decode the json data to object
                                let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                                
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                }
                break
            case .failure(let error):
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                break
            }
        })
    }
    
    // initiate voice
    public func initiateVoice(initiateVoiceEntity: InitiateVoiceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<InitiateVoiceResponseEntity>) -> Void) {
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
            "verification_api_version" : "2"
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        initiateVoiceEntity.deviceInfo = deviceInfoEntity
        initiateVoiceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(initiateVoiceEntity)
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
        urlString = baseURL + URLHelper.shared.getInitiateVoiceURL()
        
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
                            let initiateVoiceResponseEntity = try decoder.decode(InitiateVoiceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: initiateVoiceResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_INITIATE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_INITIATE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_VOICE_INITIATE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_INITIATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_INITIATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  ErrorResponseEntity())))
                }
                break
            }
        }
    }
    
    // Authenticate voice
    public func authenticateVoice(voice: Data, authenticateVoiceEntity: AuthenticateVoiceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<AuthenticateVoiceResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "verification_api_version": "2"
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        authenticateVoiceEntity.deviceInfo = deviceInfoEntity
        authenticateVoiceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["statusId"] = authenticateVoiceEntity.statusId
        bodyParams["pushNotificationId"] = deviceInfoEntity.pushNotificationId
        bodyParams["deviceMake"] = deviceInfoEntity.deviceMake
        bodyParams["deviceModel"] = deviceInfoEntity.deviceModel
        bodyParams["deviceId"] = deviceInfoEntity.deviceId
        bodyParams["client_id"] = authenticateVoiceEntity.client_id
        bodyParams["usage_pass"] = authenticateVoiceEntity.usage_pass
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getAuthenticateVoiceURL()
        
        // call service
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        // call service
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in bodyParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if authenticateVoiceEntity.usage_pass != "" {
                    multipartFormData.append(voice, withName: "voice", fileName: "voice.wav", mimeType: "audio/mpeg")
                }
                enrolledURL.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
                
        }, with: enrolledURL,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                    if response.response?.statusCode == 200 {
                        if let jsonString = response.result.value {
                            let decoder = JSONDecoder()
                            do {
                                let data = jsonString.data(using: .utf8)!
                                // decode the json data to object
                                let authenticateVoiceResponseEntity = try decoder.decode(AuthenticateVoiceResponseEntity.self, from: data)
                                
                                // return success
                                callback(Result.success(result: authenticateVoiceResponseEntity))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_ENROLLED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_VOICE_ENROLLED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                    else {
                        if let jsonString = response.result.value {
                            let decoder = JSONDecoder()
                            do {
                                let data = jsonString.data(using: .utf8)!
                                // decode the json data to object
                                let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
                                
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_VOICE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.VOICE_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                }
                break
            case .failure(let error):
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.VOICE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                break
            }
        })
    }
}
