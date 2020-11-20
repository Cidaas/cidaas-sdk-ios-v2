//
//  LoginServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LoginServiceWorker {
    
    public static var shared: LoginServiceWorker = LoginServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: LoginURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = LoginURLHelper.shared
    }
    
    public func logout(access_token : String, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void){
        // local variables
               var urlString : String
               var baseURL : String
               
               // assign base url
               baseURL = (properties["DomainURL"]) ?? ""
               
               if (baseURL == "") {
                   callback(nil, WebAuthError.shared.propertyMissingException())
                   return
               }
               
               // construct url
               urlString = baseURL + sharedURL.getLogout(accessToken: access_token)
               // urlString = baseURL + "/session/end_session?access_token_hint="+access_token
               
               sharedSession.startSession(url: urlString, method: .get, parameters: nil, callback: callback)
    }
    
    // login with credentials service
    public func loginWithCredentials(incomingData : LoginEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
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
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if (baseURL == "") {
            callback(nil, WebAuthError.shared.propertyMissingException())
            return
        }
        
        // construct url
        urlString = baseURL + sharedURL.getLoginWithCredentialsURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
}
