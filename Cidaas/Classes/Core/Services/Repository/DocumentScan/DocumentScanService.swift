//
//  DocumentScanService.swift
//  Cidaas
//
//  Created by ganesh on 30/10/18.
//

import Foundation
import Alamofire

public class DocumentScanService {
    
    // shared instance
    public static var shared : DocumentScanService = DocumentScanService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // enroll document call
    public func enrollDocument(access_token: String, photo : UIImage, properties : Dictionary<String, String>, callback: @escaping (Result<EnrollDocumentResponseEntity>) -> Void) {
        
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
            "access_token": access_token,
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
        urlString = baseURL + URLHelper.shared.getDocumentScanURL()
        
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
                                let enrollFaceResponseEntity = try decoder.decode(EnrollDocumentResponseEntity.self, from: data)
                                
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
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DOCUMENT_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error:errorResponseEntity)))
                            }
                            catch(let error) {
                                // return failure
                                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.EMPTY_FACE_ENROLLED_SERVICE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                            }
                        }
                        else {
                            // return failure
                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DOCUMENT_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.DOCUMENT_ENROLLED_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
                        }
                    }
                }
                break
            case .failure(let error):
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.DOCUMENT_ENROLLED_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
                break
            }
        })
        
    }
}
