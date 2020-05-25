//
//  RegistrationInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class RegistrationInteractor {
    
    public static var shared: RegistrationInteractor = RegistrationInteractor()
    var sharedService: RegistrationServiceWorker
    var sharedPresenter: RegistrationPresenter
    
    public init() {
        sharedService = RegistrationServiceWorker.shared
        sharedPresenter = RegistrationPresenter.shared
    }
    
    // Get registration fields
    public func getRegistrationFields(acceptlanguage: String, requestId: String, callback: @escaping(Result<RegistrationFieldsResponseEntity>) -> Void) {
        
        // validation
        if (acceptlanguage == "" || requestId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "acceptlanguage or requestId cannot be empty", statusCode: 417)
            sharedPresenter.getRegistrationFields(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getRegistrationFields(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getRegistrationFields(acceptlanguage: acceptlanguage, requestId: requestId, properties: savedProp!) { response, error in
            self.sharedPresenter.getRegistrationFields(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // Register user
    public func registerUser(requestId: String, incomingData: RegistrationEntity, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        
        // validation
        if (requestId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "requestId cannot be empty", statusCode: 417)
            sharedPresenter.registerUser(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.registerUser(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.registerUser(requestId: requestId, incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.registerUser(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // update user service
    public func updateUser(access_token: String, incomingData: RegistrationEntity, callback: @escaping(Result<UpdateUserResponseEntity>) -> Void) {
        
        // validation
        if (access_token == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "access_token or sub cannot be empty", statusCode: 417)
            sharedPresenter.updateUser(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.updateUser(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.updateUser(access_token: access_token, incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.updateUser(response: response, errorResponse: error, callback: callback)
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
