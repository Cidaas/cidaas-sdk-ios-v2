//
//  ConsentPresenter.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ConsentPresenter {
    
    public static var shared: ConsentPresenter = ConsentPresenter()
    
    public init() {}
    
    // get consent details
    public func getConsentDetails(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<ConsentDetailsResponseEntity>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let resp = try decoder.decode(ConsentDetailsResponseEntity.self, from: data)
                
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
    
    // accept consent
    public func acceptConsent(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<AcceptConsentResponseEntity>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let resp = try decoder.decode(AcceptConsentResponseEntity.self, from: data)
                
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
    
    // consent continue service
    public func consentContinue(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<LoginResponseEntity>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let resp = try decoder.decode(AuthzCodeEntity.self, from: data)
                
                logw(response ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                
                // get accesstoken from code
                AccessTokenController.shared.getAccessToken(code: resp.data.code) {
                    switch $0 {
                    case .failure(let error):
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tokenResponse):
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: tokenResponse))
                        }
                        return
                    }
                }
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: response))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
}
