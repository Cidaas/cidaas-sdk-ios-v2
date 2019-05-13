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
    
    public func enroll(verificationType: String, incomingData: EnrollRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
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
    
    public func authenticate(verificationType: String, incomingData: AuthenticateRequest, properties: Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
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
                callback(dataResponse, nil)
            }
            else {
                callback(response.description, nil)
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
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: dataResponse, statusCode: 400))
            }
            else {
                callback(nil, WebAuthError.shared.serviceFailureException(errorCode: 500, errorMessage: error.localizedDescription, statusCode: 500))
            }
            break
        }
    }
}
