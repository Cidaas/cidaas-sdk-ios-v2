//
//  SessionManager.swift
//  Cidaas
//
//  Created by Ganesh on 11/05/20.
//

import Foundation
import Alamofire
import UIKit

public class SessionManager {
    
    public static var shared : SessionManager = SessionManager()
    public var headers: HTTPHeaders
    public var session: Session
    var deviceInfo: DeviceInfoModel
    var push_id: String
    
    public init() {
        
        // get device information
        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        // custom headers
        let location = DBHelper.shared.getLocation()
        headers = AF.session.configuration.headers
        headers["User-Agent"] = CidaasUserAgentBuilder.shared.UAString()
        headers["lat"] = location.0
        headers["lon"] = location.1
        headers["deviceId"] = deviceInfoEntity.deviceId
        headers["deviceMake"] = deviceInfoEntity.deviceMake
        headers["deviceModel"] = deviceInfoEntity.deviceModel
        headers["deviceVersion"] = deviceInfoEntity.deviceVersion
        
        // configuration
        let configuration = URLSessionConfiguration.af.default
        configuration.headers = headers
        
        // session manager
        session = Session(configuration: configuration)
        
        // construct device details
        deviceInfo = DBHelper.shared.getDeviceInfo()
        push_id = DBHelper.shared.getFCM()
    }
    
    func startSession(url: String, method: HTTPMethod, parameters: [String: Any]?, extraheaders: [String: String] = [String: String](), callback: @escaping (String?, WebAuthError?) -> Void) {
        
        var bodyParams = parameters
        
        if parameters != nil {
            bodyParams!["device_id"] = deviceInfo.deviceId
            bodyParams!["push_id"] = DBHelper.shared.getFCM()
        }
        
        for(key, value) in extraheaders {
            headers[key] = value
        }
        if let locale = bodyParams?["locale"] as? String {
            headers["Accept-Language"]  = locale
        }
        
        print("=============Header============")
        print(headers)
        print("===================url=============")
        print(url)
        
        session.request(url, method: method, parameters: bodyParams, encoding: JSONEncoding.default, headers: headers).validate().responseString(encoding: .utf8) { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    func uploadPhoto(url: URLRequest, parameters: [String: String], photo: UIImage, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlReq: URLRequest = url
        session.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            
            let uploadImage = photo.jpegData(compressionQuality: 0.01)
            multipartFormData.append(uploadImage!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
            urlReq.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
        }, with: urlReq)
        .responseString(completionHandler: { data in
            self.responseRedirect(response: data, callback: callback)
        })
    }
    
    func uploadAudio(url: URLRequest, parameters: [String: String], voice: Data, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlReq: URLRequest = url
        session.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(voice, withName: "voice", fileName: "voice.wav", mimeType: "audio/mpeg")
            urlReq.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
        }, with: urlReq)
        .responseString(completionHandler: { data in
            self.responseRedirect(response: data, callback: callback)
        })
    }
    
    func responseRedirect(response: AFDataResponse<String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        switch response.result {
        case .success(let value):
            if (response.response?.statusCode == 200) {
                callback(value, nil)
                return
            }
            if (response.response?.statusCode == 204) {
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 204, errorMessage: "No data found", statusCode: response.response?.statusCode ?? 400))
            }
            else if response.data != nil {
                var dataResponse = String(decoding: response.data!, as: UTF8.self)
                let errorData = extractErrorResponseData(from: dataResponse)
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: errorData.errorCode, errorMessage: errorData.errorMessage ?? "", statusCode: response.response?.statusCode ?? 400))
            }
            else {
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: response.description, statusCode: response.response?.statusCode ?? 400))
            }
            
            break
        case .failure(let error):
            if error._domain == NSURLErrorDomain {
                // return failure
                callback(nil, WebAuthError.shared.netWorkTimeoutException())
                return
            }
            if response.data != nil {
                var dataResponse = String(decoding: response.data!, as: UTF8.self)
                let errorData = extractErrorResponseData(from: dataResponse)
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: errorData.errorCode, errorMessage: errorData.errorMessage ?? "", statusCode: response.response?.statusCode ?? 400))
            }
            else {
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: response.response?.statusCode ?? 400))
            }
            break
        }
    }
    
    public func string2error(string: String) -> ErrorResponseEntity {
        let decoder = JSONDecoder()
        do {
            let data = string.data(using: .utf8)!
            // decode the json data to object
            let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
            
            // return failure
            return errorResponseEntity
        }
        catch( _) {
            // return failure
            let errorResponseEntity = ErrorResponseEntity()
            errorResponseEntity.success = false
            errorResponseEntity.status = 400
            return errorResponseEntity
        }
    }
}


// Function to extract value dynamically for one level or two levels deep
func getDynamicValue(from json: [String: Any], keys: [String]) -> Any? {
    for key in keys {
        let keyComponents = key.split(separator: ".").map { String($0) }
        var currentObject: Any? = json
        
        for component in keyComponents {
            if let dictionary = currentObject as? [String: Any] {
                currentObject = dictionary[component]
            } else {
                currentObject = nil
                break
            }
        }
        
        // If a valid value is found for the current key path, return it
        if currentObject != nil {
            return currentObject
        }
    }
    return nil
}

// Function to parse JSON string and extract both errorCode and errorMessage
func extractErrorResponseData(from jsonString: String) -> (errorCode: String?, errorMessage: String?) {
    var errorCode: String = ""
    var errorMessage: String = ""
    
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                
                // List of possible key paths for errorCode
                let possibleErrorCodeKeyPaths = ["code", "error.code"]
                
                // Get errorCode and convert it to String if possible
                if let value = getDynamicValue(from: jsonObject, keys: possibleErrorCodeKeyPaths) {
                    if let stringValue = value as? String {
                        errorCode = stringValue
                    } else if let intValue = value as? Int {
                        errorCode = String(intValue)
                    }
                }
                
                // Handle errorMessage for both single-level and nested "error" keys
                if let errorValue = jsonObject["error"] {
                    if let errorString = errorValue as? String {
                        // Case 1: "error" is a string
                        errorMessage = errorString
                    } else if let errorDict = errorValue as? [String: Any], let nestedError = errorDict["error"] as? String {
                        // Case 2: "error" is a dictionary with an inner "error" string
                        errorMessage = nestedError
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    return (errorCode, errorMessage)
}
