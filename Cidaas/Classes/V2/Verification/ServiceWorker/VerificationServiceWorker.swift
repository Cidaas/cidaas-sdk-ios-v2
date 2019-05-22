//
//  VerificationServiceWorker.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation
import Alamofire

public class VerificationServiceWorker {
    
    public static var shared : VerificationServiceWorker = VerificationServiceWorker()
    public var headers: HTTPHeaders
    public var sessionManager: SessionManager
    
    public init() {
        // custom headers
        headers = Alamofire.SessionManager.defaultHTTPHeaders
        
        // configuration
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers

        // session manager
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    public func scanned(verificationType: String, incomingData: ScannedRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getScannedURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func enroll(verificationType: String, photo: UIImage, voice: Data, incomingData: EnrollRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getEnrolledURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParamsDefault = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParamsDefault = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        // construct body params for FACE & VOICE
        var bodyParams = Dictionary<String, String>()
        bodyParams["push_id"] = incomingData.push_id
        bodyParams["device_id"] = incomingData.device_id
        bodyParams["exchange_id"] = incomingData.exchange_id
        bodyParams["client_id"] = incomingData.client_id
        bodyParams["attempt"] = String(describing: incomingData.attempt)
        
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        switch verificationType {
        case VerificationTypes.FACE.rawValue:
            sessionManager.upload(multipartFormData: { multipartFormData in
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
                        self.responseRedirect(response: response, callback: callback)
                    }
                case .failure(let error):
                    callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: 500))
                    break
                }
            })
            break
        case VerificationTypes.VOICE.rawValue:
            sessionManager.upload(multipartFormData: { multipartFormData in
                for (key, value) in bodyParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(voice, withName: "voice", fileName: "voice.wav", mimeType: "audio/mpeg")
                enrolledURL.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
            }, with: enrolledURL,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        self.responseRedirect(response: response, callback: callback)
                    }
                case .failure(let error):
                    callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: 500))
                    break
                }
            })
            break
        default:
            sessionManager.request(urlString, method: .post, parameters: bodyParamsDefault, encoding: JSONEncoding.default).validate().responseString { response in
                self.responseRedirect(response: response, callback: callback)
            }
            break
        }
    }
    
    public func initiate(verificationType: String, incomingData: InitiateRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getInitiateURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func pushAcknowledge(verificationType: String, incomingData: PushAcknowledgeRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getPushAcknowledgeURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func pushAllow(verificationType: String, incomingData: PushAllowRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getPushAllowURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func pushReject(verificationType: String, incomingData: PushRejectRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getPushRejectURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func authenticate(verificationType: String, photo: UIImage, voice: Data, incomingData: AuthenticateRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getAuthenticateURL(verificationType: verificationType)
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParamsDefault = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParamsDefault = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        // construct body params for FACE & VOICE
        var bodyParams = Dictionary<String, String>()
        bodyParams["push_id"] = incomingData.push_id
        bodyParams["device_id"] = incomingData.device_id
        bodyParams["exchange_id"] = incomingData.exchange_id
        bodyParams["client_id"] = incomingData.client_id
        
        var enrolledURL = try! URLRequest(url: URL(string: urlString)!, method: .post, headers: headers)
        
        switch verificationType {
        case VerificationTypes.FACE.rawValue:
            sessionManager.upload(multipartFormData: { multipartFormData in
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
                        self.responseRedirect(response: response, callback: callback)
                    }
                case .failure(let error):
                    callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: 500))
                    break
                }
            })
            break
        case VerificationTypes.VOICE.rawValue:
            sessionManager.upload(multipartFormData: { multipartFormData in
                for (key, value) in bodyParams {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(voice, withName: "voice", fileName: "voice.wav", mimeType: "audio/mpeg")
                enrolledURL.addValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
            }, with: enrolledURL,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        self.responseRedirect(response: response, callback: callback)
                    }
                case .failure(let error):
                    callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: 500))
                    break
                }
            })
            break
        default:
            sessionManager.request(urlString, method: .post, parameters: bodyParamsDefault, encoding: JSONEncoding.default).validate().responseString { response in
                self.responseRedirect(response: response, callback: callback)
            }
            break
        }
    }
    
    public func deleteAll(incomingData: DeleteRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getDeleteAllURL(deviceId: deviceInfo.deviceId)
        
        sessionManager.request(urlString, method: .delete, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func delete(incomingData: DeleteRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getDeleteURL(verificationType: incomingData.verificationType, sub: incomingData.sub)
        
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .delete, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func getConfiguredList(incomingData: MFAListRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        var urlString : String
        
        // assign base url
        let baseURL = (properties["DomainURL"])!
        
        // construct scanned url
        urlString = baseURL + VerificationURLHelper.shared.getConfiguredListURL()
        
        // construct device details
        let deviceInfo = DBHelper.shared.getDeviceInfo()
        let push_id = DBHelper.shared.getFCM()
        incomingData.device_id = deviceInfo.deviceId
        incomingData.push_id = push_id
        
        // construct body params
        var bodyParams = Dictionary<String, Any>()
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        sessionManager.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).validate().responseString { response in
            self.responseRedirect(response: response, callback: callback)
        }
    }
    
    public func responseRedirect(response: DataResponse<String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        switch response.result {
        case .success:
            if response.response?.statusCode == 200 && response.result.value != nil {
                callback(response.result.value, nil)
            }
            else if response.data != nil {
                let dataResponse = String(decoding: response.data!, as: UTF8.self)
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: dataResponse, statusCode: 400, error: string2error(string: dataResponse)))
            }
            else {
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: response.description, statusCode: 400))
            }
            break
        case .failure(let error):
            if error._domain == NSURLErrorDomain {
                // return failure
                callback(nil, WebAuthError.shared.netWorkTimeoutException())
                return
            }
            else if response.data != nil {
                let dataResponse = String(decoding: response.data!, as: UTF8.self)
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: dataResponse, statusCode: 400, error: string2error(string: dataResponse)))
            }
            else {
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: 500))
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
