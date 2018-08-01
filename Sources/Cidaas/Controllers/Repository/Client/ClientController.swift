//
//  ClientController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ClientController {
    
    // shared instance
    public static var shared : ClientController = ClientController()
    
    // constructor
    public init() {
        
    }
    
    // get client info
    public func getClientInfo(requestId: String, properties: Dictionary<String, String>, callback: @escaping(Result<ClientInfoResponseEntity>) -> Void) {
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
        
        // validating fields
        if (requestId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call get client info service
        ClientService.shared.getClientInfo(requestId: requestId, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Tenant-Info service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let clientInfoResponse):
                // log success
                let loggerMessage = "Client-Info service success : " + "Client Name  - " + String(describing: clientInfoResponse.data.client_name)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: clientInfoResponse))
                }
            }
        }
    }
}
