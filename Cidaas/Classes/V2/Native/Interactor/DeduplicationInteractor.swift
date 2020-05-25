//
//  DeduplicationInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class DeduplicationInteractor {
    
    public static var shared: DeduplicationInteractor = DeduplicationInteractor()
    var sharedService: DeduplicationServiceWorker
    var sharedPresenter: DeduplicationPresenter
    
    public init() {
        sharedService = DeduplicationServiceWorker.shared
        sharedPresenter = DeduplicationPresenter.shared
    }
    
    // Get Deduplication details
    public func getDeduplicationDetails(track_id: String, callback: @escaping(Result<DeduplicationDetailsResponseEntity>) -> Void) {
        
        // validation
        if (track_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "track_id cannot be empty", statusCode: 417)
            sharedPresenter.getDeduplicationDetails(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getDeduplicationDetails(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getDeduplicationDetails(track_id: track_id, properties: savedProp!) { response, error in
            self.sharedPresenter.getDeduplicationDetails(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // Register Deduplication 
    public func registerDeduplication(track_id: String, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        
        // validation
        if (track_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "track_id cannot be empty", statusCode: 417)
            sharedPresenter.registerDeduplication(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.registerDeduplication(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.registerDeduplication(track_id: track_id, properties: savedProp!) { response, error in
            self.sharedPresenter.registerDeduplication(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // Deduplication Login
    public func deduplicationLogin(incomingData : LoginEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.username == "" || incomingData.password == "" || incomingData.username_type == "" || incomingData.requestId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "username or password or username_type or requestId cannot be empty", statusCode: 417)
            sharedPresenter.deduplicationLogin(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.deduplicationLogin(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.deduplicationLogin(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.deduplicationLogin(response: response, errorResponse: error, callback: callback)
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
