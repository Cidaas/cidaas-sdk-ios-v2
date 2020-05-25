//
//  SettingsInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class SettingsInteractor {
    
    public static var shared: SettingsInteractor = SettingsInteractor()
    var sharedService: SettingsServiceWorker
    var sharedPresenter: SettingsPresenter
    
    public init() {
        sharedService = SettingsServiceWorker.shared
        sharedPresenter = SettingsPresenter.shared
    }
    
    // Get Endpoints
    public func getEndpoints(callback: @escaping(Result<EndpointsResponseEntity>) -> Void) {
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getEndpoints(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getEndpoints(properties: savedProp!) { response, error in
            self.sharedPresenter.getEndpoints(response: response, errorResponse: error, callback: callback)
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
