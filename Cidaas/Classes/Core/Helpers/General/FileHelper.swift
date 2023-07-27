//
//  FileHelper.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class FileHelper: NSObject {
    
    // shared instance
    public static var shared : FileHelper = FileHelper()
    public var filename: String = "Cidaas"
    
    // read properties
    public func readProperties(callback: @escaping (Result<Dictionary<String, String>>)-> Void) {
        if let path = Bundle.main.path(forResource: self.filename, ofType: "plist") {
            
            var properties = Dictionary<String, String>()
            
            if let dict = NSDictionary(contentsOfFile: path) {
                if let domainURL = dict.object(forKey: "DomainURL") {
                    properties["DomainURL"] = (domainURL as? String) ?? ""
                }
                else {
                    // domain url not found
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
                    return
                }
                if let clientId = dict.object(forKey: "ClientId") {
                    properties["ClientId"] = (clientId as? String) ?? ""
                }
                else {
                    // client id not found
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
                    return
                }
                
                if let redirectURL = dict.object(forKey: "RedirectURL") {
                    properties["RedirectURL"] = (redirectURL as? String) ?? ""
                }
                else {
                    // redirect URL not found
                    // return failure
                    callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
                    return
                }

                 if let cidaasVersion = dict.object(forKey: "CidaasVersion") {
                    properties["CidaasVersion"] = (cidaasVersion as? String) ?? ""
                }
                
                // return success
                callback(Result.success(result: properties))
            }
            else {
                // no content in file
                // return failure
                callback(Result.failure(error: WebAuthError.shared.noContentInFileException()))
            }
        }
        else {
            // file not found
            // return failure
            callback(Result.failure(error: WebAuthError.shared.fileNotFoundException()))
        }
    }
    
    // params to dictionary
    public func paramsToDictionaryConverter(domainURL : String, clientId : String, redirectURL : String, clientSecret : String = "", callback: @escaping (Result<Dictionary<String, String>>)-> Void) {
        var properties = Dictionary<String, String>()
        
        // null check
        if domainURL == "" {
            // return failure
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        if clientId == "" {
            // return failure
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        // assign properties
        properties["DomainURL"] = domainURL
        properties["ClientId"] = clientId
        properties["RedirectURL"] = redirectURL
        properties["ClientSecret"] = clientSecret
        
        // return success
        callback(Result.success(result: properties))
    }
}
