//
//  VerificationInteractor.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class VerificationInteractor {
    
    public init() {}
    
    public static var shared: VerificationInteractor = VerificationInteractor()
    
    public func scanned(verificationType: String, incomingData: ScannedRequest, callback: @escaping (Result<ScannedResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.client_id == "" || incomingData.exchange_id == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or client_id or exchange_id or sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.scanned(scannedResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.scanned(scannedResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.scanned(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.scanned(scannedResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func enroll(verificationType: String, photo: UIImage = UIImage(), voice: Data = Data(), incomingData: EnrollRequest, callback: @escaping (Result<EnrollResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.client_id == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or client_id or exchange_id or pass_code cannot be empty", statusCode: 417)
            VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.enroll(verificationType: verificationType, photo: photo, voice: voice, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.enroll(enrollResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func initiate(verificationType: String, incomingData: InitiateRequest, callback: @escaping (Result<InitiateResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.sub == "" || incomingData.request_id == "" || incomingData.medium_id == "" || incomingData.usage_type == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or sub or request_id or medium_id or usage_type cannot be empty", statusCode: 417)
            VerificationPresenter.shared.initiate(initiateResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.initiate(initiateResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.initiate(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.initiate(initiateResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func pushAcknowledge(verificationType: String, incomingData: PushAcknowledgeRequest, callback: @escaping (Result<PushAcknowledgeResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "" || incomingData.client_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id or client_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAcknowledge(pushAcknowledgeResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAcknowledge(pushAcknowledgeResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.pushAcknowledge(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.pushAcknowledge(pushAcknowledgeResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func pushAllow(verificationType: String, incomingData: PushAllowRequest, callback: @escaping (Result<PushAllowResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "" || incomingData.client_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id or client_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAllow(pushAllowResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAllow(pushAllowResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.pushAllow(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.pushAllow(pushAllowResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func pushReject(verificationType: String, incomingData: PushRejectRequest, callback: @escaping (Result<PushRejectResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "" || incomingData.client_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id or client_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushReject(pushRejectResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushReject(pushRejectResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.pushReject(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.pushReject(pushRejectResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func authenticate(verificationType: String, photo: UIImage = UIImage(), voice: Data = Data(), incomingData: AuthenticateRequest, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.client_id == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or client_id or exchange_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.authenticate(verificationType: verificationType, photo: photo, voice: voice, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.authenticate(authenticateResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func delete(incomingData: DeleteRequest, callback: @escaping (Result<DeleteResponse>) -> Void) {
        // validation
        if (incomingData.client_id == "" || incomingData.sub == "" || incomingData.verificationType == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "client_id or sub or exchange_id or verificationType cannot be empty", statusCode: 417)
            VerificationPresenter.shared.delete(deleteResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.deleteAll(deleteResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.delete(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.delete(deleteResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func deleteAll(incomingData: DeleteRequest, callback: @escaping (Result<DeleteResponse>) -> Void) {
        // validation
        if (incomingData.client_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "client_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.deleteAll(deleteResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.deleteAll(deleteResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.deleteAll(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.deleteAll(deleteResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getConfiguredList(incomingData: MFAListRequest, callback: @escaping (Result<MFAListResponse>) -> Void) {
        // validation
        if (incomingData.client_id == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getConfiguredList(mfaListResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getConfiguredList(mfaListResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.getConfiguredList(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.getConfiguredList(mfaListResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getPendingNotificationList(incomingData: PendingNotificationRequest, callback: @escaping (Result<PendingNotificationResponse>) -> Void) {
        // validation
        if (incomingData.client_id == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "client_id or sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getPendingNotificationList(pendingNotificationListResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getPendingNotificationList(pendingNotificationListResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.getPendingNotificationList(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.getPendingNotificationList(pendingNotificationListResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getAuthenticatedHistoryList(incomingData: AuthenticatedHistoryRequest, callback: @escaping (Result<AuthenticatedHistoryResponse>) -> Void) {
        // validation
        if (incomingData.client_id == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "client_id or sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getAuthenticatedHistoryList(authenticatedHistoryListResponse: nil, errorResponse: error, callback: callback)
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getAuthenticatedHistoryList(authenticatedHistoryListResponse: nil, errorResponse: error, callback: callback)
        }
        
        // call worker
        VerificationServiceWorker.shared.getAuthenticatedHistoryList(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.getAuthenticatedHistoryList(authenticatedHistoryListResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    func getProperties() -> Dictionary<String, String>? {
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            return savedProp!
        }
        return nil
    }
    
    public func askForTouchorFaceIdForEnroll(incomingData: EnrollRequest, callback: @escaping (Result<EnrollResponse>) -> Void) {
        // ask for touch id or face id
        let touchId = TouchID()
        touchId.checkIfTouchIdAvailable { (success, errorMessage, errorCode) in
            if success == true {
                touchId.checkTouchIDMatching(localizedReason: incomingData.localizedReason, callback: { (res_success, res_errorMessage, res_errorCode) in
                    if res_success == true {
                        self.enroll(verificationType: VerificationTypes.TOUCH.rawValue, incomingData: incomingData, callback: callback)
                    }
                    else {
                        // send response to presenter
                        let error = WebAuthError.shared
                        error.errorMessage = res_errorMessage ?? WebAuthError.shared.errorMessage
                        error.errorCode = res_errorCode ?? WebAuthError.shared.errorCode
                        let errorResponse = error.error
                        errorResponse.error.code = res_errorCode ?? WebAuthError.shared.errorCode
                        
                        VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
                        
                        return
                    }
                })
            }
            else {
                // send response to presenter
                let error = WebAuthError.shared
                error.errorMessage = errorMessage ?? WebAuthError.shared.errorMessage
                error.errorCode = errorCode ?? WebAuthError.shared.errorCode
                let errorResponse = error.error
                errorResponse.error.code = errorCode ?? WebAuthError.shared.errorCode
                
                VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
                return
            }
        }
    }
    
    public func askForTouchorFaceIdForAuthenticate(incomingData: AuthenticateRequest, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        // ask for touch id or face id
        let touchId = TouchID()
        touchId.checkIfTouchIdAvailable { (success, errorMessage, errorCode) in
            if success == true {
                touchId.checkTouchIDMatching(localizedReason: incomingData.localizedReason, callback: { (res_success, res_errorMessage, res_errorCode) in
                    if res_success == true {
                        self.authenticate(verificationType: VerificationTypes.TOUCH.rawValue, incomingData: incomingData, callback: callback)
                    }
                    else {
                        // send response to presenter
                        let error = WebAuthError.shared
                        error.errorMessage = res_errorMessage ?? WebAuthError.shared.errorMessage
                        error.errorCode = res_errorCode ?? WebAuthError.shared.errorCode
                        let errorResponse = error.error
                        errorResponse.error.code = res_errorCode ?? WebAuthError.shared.errorCode
                        
                        VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
                        
                        return
                    }
                })
            }
            else {
                // send response to presenter
                let error = WebAuthError.shared
                error.errorMessage = errorMessage ?? WebAuthError.shared.errorMessage
                error.errorCode = errorCode ?? WebAuthError.shared.errorCode
                let errorResponse = error.error
                errorResponse.error.code = errorCode ?? WebAuthError.shared.errorCode
                
                VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
                return
            }
        }
    }
}
