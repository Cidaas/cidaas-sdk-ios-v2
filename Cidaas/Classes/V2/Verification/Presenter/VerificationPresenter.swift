//
//  VerificationPresenter.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class VerificationPresenter {
    
    public static var shared: VerificationPresenter = VerificationPresenter()
    
    public func scanned(scannedResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<ScannedResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = scannedResponse!.data(using: .utf8)!
                // decode the json data to object
                let scannedResp = try decoder.decode(ScannedResponse.self, from: data)
                
                // return success
                callback(Result.success(result: scannedResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func enroll(enrollResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<EnrollResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = enrollResponse!.data(using: .utf8)!
                // decode the json data to object
                let enrollResp = try decoder.decode(EnrollResponse.self, from: data)
                
                // return success
                callback(Result.success(result: enrollResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func initiate(initiateResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<InitiateResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = initiateResponse!.data(using: .utf8)!
                // decode the json data to object
                let initiateResp = try decoder.decode(InitiateResponse.self, from: data)
                
                // return success
                callback(Result.success(result: initiateResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func pushAcknowledge(pushAcknowledgeResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PushAcknowledgeResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pushAcknowledgeResponse!.data(using: .utf8)!
                // decode the json data to object
                let pushAckResp = try decoder.decode(PushAcknowledgeResponse.self, from: data)
                
                // return success
                callback(Result.success(result: pushAckResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func pushAllow(pushAllowResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PushAllowResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pushAllowResponse!.data(using: .utf8)!
                // decode the json data to object
                let pushAllowResp = try decoder.decode(PushAllowResponse.self, from: data)
                
                // return success
                callback(Result.success(result: pushAllowResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func pushReject(pushRejectResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PushRejectResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pushRejectResponse!.data(using: .utf8)!
                // decode the json data to object
                let pushRejectResp = try decoder.decode(PushRejectResponse.self, from: data)
                
                // return success
                callback(Result.success(result: pushRejectResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func authenticate(authenticateResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = authenticateResponse!.data(using: .utf8)!
                // decode the json data to object
                let authenticateResp = try decoder.decode(AuthenticateResponse.self, from: data)
                
                // return success
                callback(Result.success(result: authenticateResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func deleteAll(deleteResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<DeleteResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = deleteResponse!.data(using: .utf8)!
                // decode the json data to object
                let deleteResp = try decoder.decode(DeleteResponse.self, from: data)
                
                // return success
                callback(Result.success(result: deleteResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func delete(deleteResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<DeleteResponse>) -> Void) {
        if errorResponse != nil {
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = deleteResponse!.data(using: .utf8)!
                // decode the json data to object
                let deleteResp = try decoder.decode(DeleteResponse.self, from: data)
                
                // return success
                callback(Result.success(result: deleteResp))
            }
            catch(let error) {
                // return failure
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
}
