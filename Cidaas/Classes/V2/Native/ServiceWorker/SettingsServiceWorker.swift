//
//  SettingsServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class SettingsServiceWorker {
    
    public static var shared: SettingsServiceWorker = SettingsServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: SettingsURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = SettingsURLHelper.shared
    }
    
    // getting Endpoints
    public func getEndpoints(properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
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
        urlString = baseURL + sharedURL.getEndpointsURL()
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil, callback: callback)
    }
}
