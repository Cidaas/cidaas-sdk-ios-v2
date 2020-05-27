//
//  UserActivityServiceWorker.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class UserActivityServiceWorker {
    
    public static var shared: UserActivityServiceWorker = UserActivityServiceWorker()
    var sharedSession: SessionManager
    var sharedURL: UserActivityURLHelper
    
    public init() {
        sharedSession = SessionManager.shared
        sharedURL = UserActivityURLHelper.shared
    }
    
    // Get Useractivity
    public func getUserActivity(accessToken : String, incomingData: UserActivityEntity, properties : Dictionary<String, String>, callback: @escaping (String?, WebAuthError?) -> Void) {
        
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
        urlString = baseURL + sharedURL.getUserActivityURL()
        
        sharedSession.startSession(url: urlString, method: .post, parameters: bodyParams, callback: callback)
    }
}
