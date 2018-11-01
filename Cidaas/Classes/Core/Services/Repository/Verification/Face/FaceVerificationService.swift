//
//  FaceVerificationService.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class FaceVerificationService {
    
    // shared instance
    public static var shared : FaceVerificationService = FaceVerificationService()
    
    // constructor
    public init() {
        
    }
    
    // setup pattern
    public func setupFace(accessToken: String, setupFaceEntity: SetupFaceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<SetupFaceResponseEntity>) -> Void) {
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
            "access_token" : accessToken,
            "access_challenge" : properties["Challenge"] ?? "",
            "access_challenge_method" : properties["Method"] ?? ""
        ]
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        setupFaceEntity.deviceInfo = deviceInfoEntity
        setupFaceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(setupFaceEntity)
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
        urlString = baseURL + URLHelper.shared.getSetupFaceURL()
        
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
                            let setupFaceResponse = try decoder.decode(SetupFaceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: setupFaceResponse))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_SETUP_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_SETUP_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_FACE_SETUP_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_SETUP_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SETUP_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_SETUP_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  response.value ?? response.error?.localizedDescription ?? "")))
                }
                break
            }
        }
    }
    
    // scanned pattern
    public func scannedFace(accessToken: String, scannedFaceEntity: ScannedFaceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<ScannedFaceResponseEntity>) -> Void) {
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
        scannedFaceEntity.deviceInfo = deviceInfoEntity
        
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(scannedFaceEntity)
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
        urlString = baseURL + URLHelper.shared.getScannedFaceURL()
        
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
                            let scannedFace = try decoder.decode(ScannedFaceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: scannedFace))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_SCANNED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_SCANNED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_FACE_SCANNED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_SCANNED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_SCANNED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_SCANNED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  response.value ?? response.error?.localizedDescription ?? "")))
                }
                break
            }
        }
    }
    
    // enroll pattern
    public func enrollFace(accessToken: String, photo: UIImage, enrollFaceEntity: EnrollFaceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<EnrollFaceResponseEntity>) -> Void) {
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
        enrollFaceEntity.deviceInfo = deviceInfoEntity
        
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        bodyParams["statusId"] = enrollFaceEntity.statusId
        bodyParams["userDeviceId"] = enrollFaceEntity.userDeviceId
        bodyParams["pushNotificationId"] = deviceInfoEntity.pushNotificationId
        bodyParams["deviceMake"] = deviceInfoEntity.deviceMake
        bodyParams["deviceModel"] = deviceInfoEntity.deviceModel
        bodyParams["deviceId"] = deviceInfoEntity.deviceId
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getEnrollFaceURL()
        
        // call service
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        // call service
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in bodyParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                
                let uploadImage = UIImageJPEGRepresentation(photo, 0.01)
                
                multipartFormData.append(uploadImage!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
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
                                let enrollFaceResponseEntity = try decoder.decode(EnrollFaceResponseEntity.self, from: data)
                                
                                // return success
                                callback(Result.success(result: enrollFaceResponseEntity))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_FACE_ENROLLED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
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
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                }
                break
            case .failure(let error):
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                break
            }
        })
    }
    
    // initiate pattern
    public func initiateFace(initiateFaceEntity: InitiateFaceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<InitiateFaceResponseEntity>) -> Void) {
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
            "access_challenge" : properties["Challenge"] ?? "",
            "access_challenge_method" : properties["Method"] ?? ""
        ]
        
        deviceInfoEntity.pushNotificationId = DBHelper.shared.getFCM()
        initiateFaceEntity.deviceInfo = deviceInfoEntity
        initiateFaceEntity.client_id = properties["ClientId"] ?? ""
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(initiateFaceEntity)
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
        urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
        
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
                            let initiateFaceResponseEntity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                            
                            // return success
                            callback(Result.success(result: initiateFaceResponseEntity))
                        }
                        catch(let error) {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_INITIATE_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                        }
                    }
                    else {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_INITIATE_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_FACE_INITIATE_SERVICE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_INITIATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_INITIATE_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_INITIATE_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400, error:  response.value ?? response.error?.localizedDescription ?? "")))
                }
                break
            }
        }
    }
    
    // Authenticate pattern
    public func authenticateFace(photo: UIImage, authenticateFaceEntity: AuthenticateFaceEntity, properties : Dictionary<String, String>, callback: @escaping(Result<AuthenticateFaceResponseEntity>) -> Void) {
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
        authenticateFaceEntity.deviceInfo = deviceInfoEntity
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(authenticateFaceEntity)
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
        urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
        
        // call service
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        // call service
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in bodyParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                
                let uploadImage = UIImageJPEGRepresentation(photo, 0.01)
                
                multipartFormData.append(uploadImage!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
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
                                let authenticateFaceResponseEntity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
                                
                                // return success
                                callback(Result.success(result: authenticateFaceResponseEntity))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_FACE_ENROLLED_SERVICE, statusCode: response.response?.statusCode ?? 400)))
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
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.FACE_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                }
                break
            case .failure(let error):
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.FACE_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                break
            }
        })
    }
}
