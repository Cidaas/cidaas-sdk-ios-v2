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
    var sharedSession: SessionManager
    
    // constructor
    public init() {
        sharedSession = SessionManager.shared
    }
    
    // get user info
    public func getUserInfo (accessToken : String, properties : Dictionary<String, String>, callback: @escaping (Result<UserInfoEntity>) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if baseURL == "" {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        var headers: [String: String] = [String: String]()
        headers["access_token"] = accessToken
        
        // construct url
        urlString = baseURL + URLHelper.shared.getUserInfoURL()
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil, extraheaders: headers) { response, error in
            
            if error != nil {
                logw(error!.errorMessage, cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: error!))
            }
            else {
                let decoder = JSONDecoder()
                do {
                    let data = response!.data(using: .utf8)!
                    // decode the json data to object
                    let resp = try decoder.decode(UserInfoEntity.self, from: data)
                    
                    logw(response ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                    
                    // return success
                    callback(Result.success(result: resp))
                }
                catch(let error) {
                    // return failure
                    logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: response))", cname: "cidaas-sdk-verification-error-log")
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
                }
            }
        }
    }
    
    // upload image
    public func uploadImage(accessToken: String, photo: UIImage, properties : Dictionary<String, String>, callback: @escaping(Result<UploadImageResponseEntity>) -> Void) {
//        // local variables
//        var headers : HTTPHeaders
//        var urlString : String
//        var baseURL : String
//
//        // construct headers
//        headers = [
//            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
//            "lat": location.0,
//            "lon": location.1,
//            "access_token" : accessToken
//        ]
//
//        // assign base url
//        baseURL = (properties["DomainURL"]) ?? ""
//
//        if (baseURL == "") {
//            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
//            return
//        }
//
//        // construct url
//        urlString = baseURL + URLHelper.shared.getImageUploadURL()
//
//        // call service
//        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
//
//        // call service
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                let uploadImage = photo.jpegData(compressionQuality: 0.01)
//
//                multipartFormData.append(uploadImage!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
//                enrolledURL.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
//
//        }, with: enrolledURL,
//           encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseString { response in
//                    if response.response?.statusCode == 200 {
//                        if let jsonString = response.result.value {
//                            let decoder = JSONDecoder()
//                            do {
//                                let data = jsonString.data(using: .utf8)!
//                                // decode the json data to object
//                                let enrollFaceResponseEntity = try decoder.decode(UploadImageResponseEntity.self, from: data)
//
//                                // return success
//                                callback(Result.success(result: enrollFaceResponseEntity))
//                            }
//                            catch(let error) {
//                                // return failure
//                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_IMAGE_UPLOAD_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                            }
//                        }
//                        else {
//                            // return failure
//                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_IMAGE_UPLOAD_SERVICE.rawValue, errorMessage: StringsHelper.shared.EMPTY_IMAGE_UPLOAD_SERVICE, statusCode: response.response?.statusCode ?? 400)))
//                        }
//                    }
//                    else {
//                        if let jsonString = response.result.value {
//                            let decoder = JSONDecoder()
//                            do {
//                                let data = jsonString.data(using: .utf8)!
//                                // decode the json data to object
//                                let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
//
//                                // return failure
//                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.IMAGE_UPLOAD_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
//                            }
//                            catch(let error) {
//                                // return failure
//                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_IMAGE_UPLOAD_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                            }
//                        }
//                        else {
//                            // return failure
//                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.IMAGE_UPLOAD_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.IMAGE_UPLOAD_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                        }
//                    }
//                }
//                break
//            case .failure(let error):
//                if error._domain == NSURLErrorDomain {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
//                    return
//                }
//                // return failure
//                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.IMAGE_UPLOAD_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                break
//            }
//        })
    }
}
