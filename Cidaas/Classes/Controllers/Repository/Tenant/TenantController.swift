//
//  TenantController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class TenantController {
 
    // shared instance
    public static var shared : TenantController = TenantController()
    
    // constructor
    public init() {
        
    }
    
    // get tenant info
    public func getTenantInfo(properties: Dictionary<String, String>, callback: @escaping(Result<TenantInfoResponseEntity>) -> Void) {
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
        
        // call get tenant info service
        TenantService.shared.getTenantInfo(properties: properties) {
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
            case .success(let tenantInfoResponse):
                // log success
                let loggerMessage = "Tenant-Info service success : " + "Tenant Name  - " + String(describing: tenantInfoResponse.data.tenant_name)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: tenantInfoResponse))
                }
            }
        }
    }
}

