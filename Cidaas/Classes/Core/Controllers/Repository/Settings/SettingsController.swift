//
//  SettingsController.swift
//  Cidaas
//
//  Created by ganesh on 27/11/18.
//

import Foundation

public class SettingsController {
    
    // shared instance
    public static var shared : SettingsController = SettingsController()
    
    // constructor
    public init() {
        
    }
    
    // get end points
    public func getEndpoints(properties: Dictionary<String, String>, callback: @escaping (Result<EndpointsResponseEntity>) -> Void) {
        
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call getEndpoints service
        SettingsService.shared.getEndpoints(properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get endpoints service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Get endpoints service success : " + "Authz URL - " + serviceResponse.authorization_endpoint
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
}
