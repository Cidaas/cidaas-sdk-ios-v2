//
//  ResetPasswordInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class ResetPasswordInteractor {
    
    public static var shared: ResetPasswordInteractor = ResetPasswordInteractor()
    var sharedService: ResetPasswordServiceWorker
    var sharedPresenter: ResetPasswordPresenter
    
    public init() {
        sharedService = ResetPasswordServiceWorker.shared
        sharedPresenter = ResetPasswordPresenter.shared
    }
    
    // Initiate reset password
    public func initiateResetPassword(incomingData : InitiateResetPasswordEntity, callback: @escaping(Result<InitiateResetPasswordResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.requestId == "" || incomingData.processingType == "" || incomingData.resetMedium == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "requestId or processingType or resetMedium cannot be empty", statusCode: 417)
            sharedPresenter.initiateResetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        if (incomingData.resetMedium == "email" && incomingData.email == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "email cannot be empty", statusCode: 417)
            sharedPresenter.initiateResetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        if (incomingData.resetMedium == "mobile" && incomingData.mobile == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "mobile cannot be empty", statusCode: 417)
            sharedPresenter.initiateResetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.initiateResetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.initiateResetPassword(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.initiateResetPassword(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // Handle reset password
    public func handleResetPassword(incomingData : HandleResetPasswordEntity, callback: @escaping(Result<HandleResetPasswordResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.code == "" || incomingData.resetRequestId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "code or resetRequestId cannot be empty", statusCode: 417)
            sharedPresenter.handleResetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.handleResetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.handleResetPassword(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.handleResetPassword(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // reset password
    public func resetPassword(incomingData : ResetPasswordEntity, callback: @escaping(Result<ResetPasswordResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.password == "" || incomingData.confirmPassword == "" || incomingData.resetRequestId == "" || incomingData.exchangeId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "password or confirmPassword or resetRequestId or exchangeId cannot be empty", statusCode: 417)
            sharedPresenter.resetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        if (incomingData.password != incomingData.confirmPassword) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "password and confirmPassword must be same", statusCode: 417)
            sharedPresenter.resetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.resetPassword(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.resetPassword(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.resetPassword(response: response, errorResponse: error, callback: callback)
        }
    }
    
    func getProperties() -> Dictionary<String, String>? {
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            return savedProp!
        }
        return nil
    }
}
