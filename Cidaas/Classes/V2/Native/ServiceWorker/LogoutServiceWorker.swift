//
//  LogoutServiceWorker.swift
//  Alamofire
//
//  Created by Kundan Kishore on 19/11/20.
//

import Foundation

public class LogoutServiceWorker {
    public static var shared: LogoutServiceWorker = LogoutServiceWorker()
       var sharedSession : SessionManager
       var sharedURL: LoginURLHelper
    
    public init() {
           sharedSession = SessionManager.shared
           sharedURL = LoginURLHelper.shared
       }
    
    public func logoutServiceWorker() -> Void {
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
        urlString = baseURL + sharedURL.getLoginWithCredentialsURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
        
    }
}
