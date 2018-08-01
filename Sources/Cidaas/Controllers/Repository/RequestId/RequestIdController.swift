//
//  RequestIdController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class RequestIdController {
    
    // shared instance
    public static var shared : RequestIdController = RequestIdController()
    
    // constructor
    public init() {
        
    }
    
    // get request id
    public func getRequestId(properties: Dictionary<String, String>, callback: @escaping (Result<RequestIdResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil || properties["RedirectURL"] == "" || properties["RedirectURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call get request id service
        RequestIdService.shared.getRequestId(properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Request-Id service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let requestIdResponse):
                // log success
                let loggerMessage = "Request-Id service success : " + "Request Id - " + String(describing: requestIdResponse.data.requestId)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: requestIdResponse))
                }
            }
        }
    }
}
