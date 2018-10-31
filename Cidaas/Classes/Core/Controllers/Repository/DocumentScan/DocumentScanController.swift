//
//  DocumentScanController.swift
//  Cidaas
//
//  Created by ganesh on 30/10/18.
//

import Foundation

public class DocumentScanController {
    
    // shared instance
    public static var shared : DocumentScanController = DocumentScanController()
    
    // constructor
    public init() {
        
    }
    
    // scan document from properties
    public func scanDocument(sub: String, photo: UIImage, properties: Dictionary<String, String>, callback: @escaping(Result<EnrollDocumentResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // get access token from sub
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Access token failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tokenResponse):
                // log success
                let loggerMessage = "Access Token success : " + "Access Token  - " + String(describing: tokenResponse.data.access_token)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // call enroll document service
                DocumentScanService.shared.enrollDocument(access_token: tokenResponse.data.access_token, photo: photo, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Enroll document service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let serviceResponse):
                        // log success
                        let loggerMessage = "Enroll document service success : " + "Name  - " + String(describing: serviceResponse.data.Name)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: serviceResponse))
                        }
                    }
                }
            }
        }
    }
}
