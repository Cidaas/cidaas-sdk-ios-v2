//
//  TenantPresenter.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class TenantPresenter {
    
    public static var shared: TenantPresenter = TenantPresenter()
    
    public init() {}
    
    // Tenant Info
    public func getTenantInfo(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<TenantInfoResponseEntity>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let resp = try decoder.decode(TenantInfoResponseEntity.self, from: data)
                
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
