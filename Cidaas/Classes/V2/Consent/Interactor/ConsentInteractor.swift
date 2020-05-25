//
//  ConsentInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ConsentInteractor {
    
    public static var shared: ConsentInteractor = ConsentInteractor()
    var sharedService: ConsentServiceWorker
    var sharedPresenter: ConsentPresenter
    
    public init() {
        sharedService = ConsentServiceWorker.shared
        sharedPresenter = ConsentPresenter.shared
    }
    
    // get consent details
    public func getConsentDetails(incomingData : ConsentDetailsRequestEntity, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.consent_id == "" || incomingData.consent_version_id == "" || incomingData.sub == "" || incomingData.track_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "consent_id or consent_version_id or sub or track_id cannot be empty", statusCode: 417)
            sharedPresenter.getConsentDetails(response: nil, errorResponse: error, callback: callback)
            return
        }

        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getConsentDetails(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getConsentDetails(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.getConsentDetails(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // accept consent
    public func acceptConsent(incomingData: AcceptConsentEntity, callback: @escaping(Result<AcceptConsentResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.consent_id == "" || incomingData.consent_version_id == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "consent_id or consent_version_id or sub cannot be empty", statusCode: 417)
            sharedPresenter.acceptConsent(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.acceptConsent(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.acceptConsent(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.acceptConsent(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // consent continue service
    public func consentContinue(incomingData: ConsentContinueEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.sub == "" || incomingData.trackId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub or trackId cannot be empty", statusCode: 417)
            sharedPresenter.consentContinue(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.consentContinue(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.consentContinue(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.consentContinue(response: response, errorResponse: error, callback: callback)
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
