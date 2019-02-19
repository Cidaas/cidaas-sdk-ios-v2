//
//  UsersService.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class UsersService {
    
    // shared instance
    public static var shared : UsersService = UsersService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // get user info
    public func getUserInfo (accessToken : String, properties : Dictionary<String, String>, callback: @escaping (Result<UserInfoEntity>) -> Void) {
        
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
            "access_token": accessToken,
            "deviceId" : deviceInfoEntity.deviceId,
            "deviceMake" : deviceInfoEntity.deviceMake,
            "deviceModel" : deviceInfoEntity.deviceModel,
            "deviceVersion" : deviceInfoEntity.deviceVersion
        ]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if baseURL == "" {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getUserInfoURL()
        
        Alamofire.request(urlString, headers: headers).validate().responseString { response in
            switch response.result {
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.USER_INFO_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
                    }
                    catch(let error) {
                        // return failure
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.USER_INFO_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.USER_INFO_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.USER_INFO_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                }
                return
            case .success:
                if response.response?.statusCode == 200 {
                    if let jsonString = response.result.value {
                        let decoder = JSONDecoder()
                        do {
                            let data = jsonString.data(using: .utf8)!
                            let userInfoEntity = try decoder.decode(UserInfoEntity.self, from: data)
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
                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.USER_INFO_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.USER_INFO_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    }
                }
                else {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.USER_INFO_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.USER_INFO_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                    break
                }
            }
        }
    }
    
    // upload image
    public func uploadImage(accessToken: String, photo: UIImage, properties : Dictionary<String, String>, callback: @escaping(Result<UploadImageResponseEntity>) -> Void) {
        // local variables
        var headers : HTTPHeaders
        var urlString : String
        var baseURL : String
        
        // construct headers
        headers = [
            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
            "lat": location.0,
            "lon": location.1,
            "access_token" : accessToken
        ]
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // construct url
        urlString = baseURL + URLHelper.shared.getImageUploadURL()
        
        // call service
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        // call service
        Alamofire.upload(
            multipartFormData: { multipartFormData in
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
                                let enrollFaceResponseEntity = try decoder.decode(UploadImageResponseEntity.self, from: data)
                                
                                // return success
                                callback(Result.success(result: enrollFaceResponseEntity))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_IMAGE_UPLOAD_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_IMAGE_UPLOAD_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_IMAGE_UPLOAD_SERVICE, statusCode: response.response?.statusCode ?? 400)))
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
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.IMAGE_UPLOAD_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_IMAGE_UPLOAD_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.IMAGE_UPLOAD_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.IMAGE_UPLOAD_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
                    return
                }
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.IMAGE_UPLOAD_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                break
            }
        })
    }
}
