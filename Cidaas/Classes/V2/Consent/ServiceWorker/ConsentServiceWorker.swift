//
//  ConsentServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ConsentServiceWorker {
    
    public static var shared: ConsentServiceWorker = ConsentServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: ConsentURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = ConsentURLHelper.shared
    }
    
    // get consent details
    public func getConsentDetails(incomingData : ConsentDetailsRequestEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            bodyParams["client_id"] = (properties["ClientId"]) ?? ""
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
        urlString = baseURL + sharedURL.getConsentDetailsURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
    
    // accept consent
    public func acceptConsent(incomingData: AcceptConsentEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // construct body params
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(incomingData)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            bodyParams["client_id"] = (properties["ClientId"]) ?? ""
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
        urlString = baseURL + sharedURL.getAcceptConsentURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
    
    // consent continue service
    public func consentContinue(incomingData: ConsentContinueEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
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
        urlString = baseURL + sharedURL.getConsentContinueURL(trackId: incomingData.trackId)
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
}
