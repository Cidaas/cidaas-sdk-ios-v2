//
//  UserActivityPresenter.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class UserActivityPresenter {
    
    public static var shared: UserActivityPresenter = UserActivityPresenter()
    
    public init() {}
    
    // Get Useractivity
    public func getUserActivity(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<UserActivityResponseEntity>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let resp = try decoder.decode(UserActivityResponseEntity.self, from: data)
                
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
