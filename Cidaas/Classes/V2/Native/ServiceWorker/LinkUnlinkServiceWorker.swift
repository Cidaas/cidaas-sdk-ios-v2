//
//  LinkUnlinkServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LinkUnlinkServiceWorker {
    
    public static var shared: LinkUnlinkServiceWorker = LinkUnlinkServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: LinkUnlinkURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = LinkUnlinkURLHelper.shared
    }
    
    // link user
    public func linkAccount(access_token: String, incomingData : LinkAccountEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
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
        
        var headers: [String: String] = [String: String]()
        headers["access_token"] = access_token
        
        // construct url
        urlString = baseURL + sharedURL.getLinkUserURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, extraheaders: headers, callback: callback)
    }
    
    // get linked users
    public func getLinkedUsers(access_token: String, sub: String, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(nil, WebAuthError.shared.propertyMissingException())
            return
        }
        
        var headers: [String: String] = [String: String]()
        headers["access_token"] = access_token
        
        // construct url
        urlString = baseURL + sharedURL.getLinkedUsersListURL(sub: sub)
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil, extraheaders: headers, callback: callback)
    }
    
    // unlink user
    public func unlinkAccount(access_token: String, identityId: String, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(nil, WebAuthError.shared.propertyMissingException())
            return
        }
        
        var headers: [String: String] = [String: String]()
        headers["access_token"] = access_token
        
        // construct url
        urlString = baseURL + sharedURL.getUnlinkUserURL(identityId: identityId)
        
        sharedSession.startSession(url: urlString, method: .post, parameters: nil, extraheaders: headers, callback: callback)
    }
}
