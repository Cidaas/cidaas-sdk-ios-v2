//
//  ResetPasswordServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class ResetPasswordServiceWorker {
    
    public static var shared: ResetPasswordServiceWorker = ResetPasswordServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: ResetpasswordURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = ResetpasswordURLHelper.shared
    }
    
    // Initiate reset password
    public func initiateResetPassword(incomingData : InitiateResetPasswordEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(nil, WebAuthError.shared.propertyMissingException())
            return
        }
        
        // construct url
        urlString = baseURL + sharedURL.getInitiateResetPasswordURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
    
    // Handle reset password
    public func handleResetPassword(incomingData : HandleResetPasswordEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(nil, WebAuthError.shared.propertyMissingException())
            return
        }
        
        // construct url
        
        // construct url
        if ((properties["CidaasVersion"] != nil) && properties["CidaasVersion"] == "3") {
            urlString = baseURL + sharedURL.getHandleResetPasswordV3URL()
        } else {
            urlString = baseURL + sharedURL.getHandleResetPasswordURL()
        }
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
    
    // reset password
    public func resetPassword(incomingData : ResetPasswordEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
        }
        catch(_) {
            callback(nil, WebAuthError.shared.conversionException())
            return
        }
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(nil, WebAuthError.shared.propertyMissingException())
            return
        }
        
        // construct url
        if ((properties["CidaasVersion"] != nil) && properties["CidaasVersion"] == "3") {
            urlString = baseURL + sharedURL.getResetPasswordV3URL()
        } else {
            urlString = baseURL + sharedURL.getResetPasswordURL()
        }
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
}
