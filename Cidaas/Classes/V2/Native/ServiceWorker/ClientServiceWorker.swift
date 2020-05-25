//
//  ClientServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class ClientServiceWorker {
    
    public static var shared: ClientServiceWorker = ClientServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: ClientURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = ClientURLHelper.shared
    }
    
    // getting Client Info
    public func getClientInfo(requestId: String, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
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
        urlString = baseURL + sharedURL.getClientInfoURL(requestId: requestId)
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil, callback: callback)
    }
}
