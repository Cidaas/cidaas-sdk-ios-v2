//
//  AccountVerificationInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class AccountVerificationInteractor {
    
    public static var shared: AccountVerificationInteractor = AccountVerificationInteractor()
    var sharedPresenter: AccountVerificationPresenter
    var sharedService: AccountVerificationServiceWorker
    
    public init() {
        sharedPresenter = AccountVerificationPresenter.shared
        sharedService = AccountVerificationServiceWorker.shared
    }
    
    public func initiateAccountVerification(incomingData : InitiateAccountVerificationEntity, callback: @escaping (Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.requestId == "" || (incomingData.sub == "" && incomingData.email == "" && incomingData.mobile == "") || incomingData.verificationMedium == "" || incomingData.processingType == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "requestId or sub or verificationMedium or processingType cannot be empty", statusCode: 417)
            sharedPresenter.initiateAccountVerification(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.initiateAccountVerification(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.initiateAccountVerification(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.initiateAccountVerification(response: response, errorResponse: error, callback: callback)
        }
    }
    
    public func verifyAccount(incomingData : VerifyAccountEntity, callback: @escaping (Result<VerifyAccountResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.accvid == "" || incomingData.code == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "accvid or code cannot be empty", statusCode: 417)
            sharedPresenter.verifyAccount(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.verifyAccount(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.verifyAccount(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.verifyAccount(response: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getAccountVerificationList(sub: String, callback: @escaping (Result<AccountVerificationListResponseEntity>) -> Void) {
        
        // validation
        if (sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            sharedPresenter.getAccountVerificationList(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getAccountVerificationList(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getAccountVerificationList(sub: sub, properties: savedProp!) { response, error in
            self.sharedPresenter.getAccountVerificationList(response: response, errorResponse: error, callback: callback)
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
