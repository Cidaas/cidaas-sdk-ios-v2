//
//  UsersService.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import Alamofire

public class UsersService {
    
    // shared instance
    public static var shared : UsersService = UsersService()
    let location = DBHelper.shared.getLocation()
    var sharedSession: SessionManager
    
    // constructor
    public init() {
        sharedSession = SessionManager.shared
    }
    
    // get user info
    public func getUserInfo (accessToken : String, properties : Dictionary<String, String>, callback: @escaping (Result<UserInfoEntity>) -> Void) {
        
        // local variables
        var urlString : String
        var baseURL : String
        
        // assign base url
        baseURL = (properties["DomainURL"]) ?? ""
        
        if baseURL == "" {
            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
            return
        }
        
        var headers: [String: String] = [String: String]()
        headers["access_token"] = accessToken
        
        // construct url
        urlString = baseURL + URLHelper.shared.getUserInfoURL()
        
        sharedSession.startSession(url: urlString, method: .get, parameters: nil, extraheaders: headers) { response, error in
            
            if error != nil {
                logw(error!.errorMessage, cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: error!))
            }
            else {
                let decoder = JSONDecoder()
                do {
                    let data = response!.data(using: .utf8)!
                    // decode the json data to object
                    let resp = try decoder.decode(UserInfoEntity.self, from: data)
                    
                    logw(response ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                    
                    // return success
                    callback(Result.success(result: resp))
                }
                catch(let error) {
                    // return failure
                    logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: response))", cname: "cidaas-sdk-verification-error-log")
                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
                }
            }
        }
    }
    

    }
