//
//  ClientPresenter.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class ClientPresenter {
    
    public static var shared: ClientPresenter = ClientPresenter()
    
    public init() {}
    
    // Client Info
    public func getClientInfo(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<ClientInfoResponseEntity>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let resp = try decoder.decode(ClientInfoResponseEntity.self, from: data)
                
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
