//
//  VerificationPresenter.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class VerificationPresenter {
    
    public static var shared: VerificationPresenter = VerificationPresenter()
    
    public func setup(response: String?, errorResponse: WebAuthError?, callback: @escaping (Result<SetupResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = response!.data(using: .utf8)!
                // decode the json data to object
                let setupResp = try decoder.decode(SetupResponse.self, from: data)
                
                logw(response ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: setupResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: response))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func scanned(scannedResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<ScannedResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = scannedResponse!.data(using: .utf8)!
                // decode the json data to object
                let scannedResp = try decoder.decode(ScannedResponse.self, from: data)
                
                logw(scannedResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: scannedResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: scannedResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func enroll(enrollResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<EnrollResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = enrollResponse!.data(using: .utf8)!
                // decode the json data to object
                let enrollResp = try decoder.decode(EnrollResponse.self, from: data)
                
                logw(enrollResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: enrollResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: enrollResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func initiate(initiateResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<InitiateResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = initiateResponse!.data(using: .utf8)!
                // decode the json data to object
                let initiateResp = try decoder.decode(InitiateResponse.self, from: data)
                
                logw(initiateResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: initiateResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: initiateResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func pushAcknowledge(pushAcknowledgeResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PushAcknowledgeResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pushAcknowledgeResponse!.data(using: .utf8)!
                // decode the json data to object
                let pushAckResp = try decoder.decode(PushAcknowledgeResponse.self, from: data)
                
                logw(pushAcknowledgeResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: pushAckResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: pushAcknowledgeResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func pushAllow(pushAllowResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PushAllowResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pushAllowResponse!.data(using: .utf8)!
                // decode the json data to object
                let pushAllowResp = try decoder.decode(PushAllowResponse.self, from: data)
                
                logw(pushAllowResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: pushAllowResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: pushAllowResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func pushReject(pushRejectResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PushRejectResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pushRejectResponse!.data(using: .utf8)!
                // decode the json data to object
                let pushRejectResp = try decoder.decode(PushRejectResponse.self, from: data)
                
                logw(pushRejectResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: pushRejectResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: pushRejectResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func authenticate(authenticateResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = authenticateResponse!.data(using: .utf8)!
                // decode the json data to object
                let authenticateResp = try decoder.decode(AuthenticateResponse.self, from: data)
                
                logw(authenticateResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: authenticateResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: authenticateResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func deleteAll(deleteResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<DeleteResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = deleteResponse!.data(using: .utf8)!
                // decode the json data to object
                let deleteResp = try decoder.decode(DeleteResponse.self, from: data)
                
                logw(deleteResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: deleteResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: deleteResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func delete(deleteResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<DeleteResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = deleteResponse!.data(using: .utf8)!
                // decode the json data to object
                let deleteResp = try decoder.decode(DeleteResponse.self, from: data)
                
                logw(deleteResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: deleteResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: deleteResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func getConfiguredList(mfaListResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<MFAListResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = mfaListResponse!.data(using: .utf8)!
                // decode the json data to object
                let mfaResp = try decoder.decode(MFAListResponse.self, from: data)
                
                logw(mfaListResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: mfaResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: mfaListResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func getPendingNotificationList(pendingNotificationListResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<PendingNotificationResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = pendingNotificationListResponse!.data(using: .utf8)!
                // decode the json data to object
                let pendingNotificationResp = try decoder.decode(PendingNotificationResponse.self, from: data)
                
                logw(pendingNotificationListResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: pendingNotificationResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: pendingNotificationListResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func getAuthenticatedHistoryList(authenticatedHistoryListResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<AuthenticatedHistoryResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = authenticatedHistoryListResponse!.data(using: .utf8)!
                // decode the json data to object
                let authResp = try decoder.decode(AuthenticatedHistoryResponse.self, from: data)
                
                logw(authenticatedHistoryListResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: authResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: authenticatedHistoryListResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func updateFCM(updateFCMResponse: String?, errorResponse: WebAuthError?) {
        if errorResponse != nil {
            if (errorResponse?.statusCode == 200) {
                logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-success-log")
            }
            else {
                logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            }
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = updateFCMResponse!.data(using: .utf8)!
                // decode the json data to object
                _ = try decoder.decode(UpdateFCMResponse.self, from: data)
                
                logw(updateFCMResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
            }
            catch(let error) {
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: updateFCMResponse))", cname: "cidaas-sdk-verification-error-log")
            }
        }
    }
    
    public func passwordlessContinue(passwordlessContinueResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<AuthzCodeResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = passwordlessContinueResponse!.data(using: .utf8)!
                // decode the json data to object
                let passwordlessResp = try decoder.decode(AuthzCodeResponse.self, from: data)
                
                logw(passwordlessContinueResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: passwordlessResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: passwordlessContinueResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func login(loginResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<LoginResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = loginResponse!.data(using: .utf8)!
                // decode the json data to object
                let loginResp = try decoder.decode(LoginResponse.self, from: data)
                
                logw(loginResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: loginResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: loginResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func updateFCMToken(fcmTokenResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<UpdateFCMResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = fcmTokenResponse!.data(using: .utf8)!
                // decode the json data to object
                let fcmTokenResp = try decoder.decode(UpdateFCMResponse.self, from: data)
                
                logw(fcmTokenResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: fcmTokenResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: fcmTokenResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func getTimeLineDetails(timeLineDetailsResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<TimeLineDetailsResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = timeLineDetailsResponse!.data(using: .utf8)!
                // decode the json data to object
                let timeLineDetailsResp = try decoder.decode(TimeLineDetailsResponse.self, from: data)
                
                logw(timeLineDetailsResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: timeLineDetailsResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: timeLineDetailsResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func getMFAConfiguredDeviceList(mfaConfiguredDeviceListResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<MFAConfiguredDeviceListResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = mfaConfiguredDeviceListResponse!.data(using: .utf8)!
                // decode the json data to object
                let mfaConfiguredDeviceListResp = try decoder.decode(MFAConfiguredDeviceListResponse.self, from: data)
                
                logw(mfaConfiguredDeviceListResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: mfaConfiguredDeviceListResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: mfaConfiguredDeviceListResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func deleteDevice(deleteDeviceResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<DeleteResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = deleteDeviceResponse!.data(using: .utf8)!
                // decode the json data to object
                let deleteDeviceResp = try decoder.decode(DeleteResponse.self, from: data)
                
                logw(deleteDeviceResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: deleteDeviceResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: deleteDeviceResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    public func getDeviceConfiguredList(deviceConfiguredListResponse: String?, errorResponse: WebAuthError?, callback: @escaping (Result<MFAListResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = deviceConfiguredListResponse!.data(using: .utf8)!
                // decode the json data to object
                let deviceConfiguredListResp = try decoder.decode(MFAListResponse.self, from: data)
                
                logw(deviceConfiguredListResponse ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: deviceConfiguredListResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: deviceConfiguredListResponse))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
    
    
    public func cancelQr(cancelQrResult: String?, errorResponse: WebAuthError?, callback: @escaping (Result<CancelQrResponse>) -> Void) {
        if errorResponse != nil {
            logw(errorResponse!.errorMessage, cname: "cidaas-sdk-verification-error-log")
            callback(Result.failure(error: errorResponse!))
        }
        else {
            let decoder = JSONDecoder()
            do {
                let data = cancelQrResult!.data(using: .utf8)!
                // decode the json data to object
                let cancelQrResp = try decoder.decode(CancelQrResponse.self, from: data)
                
                logw(cancelQrResult ?? "Empty response string", cname: "cidaas-sdk-verification-success-log")
                // return success
                callback(Result.success(result: cancelQrResp))
            }
            catch(let error) {
                // return failure
                logw("\(String(describing: error)) JSON parsing issue, Response: \(String(describing: cancelQrResult))", cname: "cidaas-sdk-verification-error-log")
                callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: error.localizedDescription, statusCode: 400)))
            }
        }
    }
}
