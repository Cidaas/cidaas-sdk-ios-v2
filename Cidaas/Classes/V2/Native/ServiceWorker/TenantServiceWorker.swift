//
//  TenantServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class TenantServiceWorker {
    
    public static var shared: TenantServiceWorker = TenantServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: TenantURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = TenantURLHelper.shared
    }
    
    // getting Tenant Info
    public func getTenantInfo(properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
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
        urlString = baseURL + sharedURL.getTenantInfoURL()
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil, callback: callback)
    }
}
