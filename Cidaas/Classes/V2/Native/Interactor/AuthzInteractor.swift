//
//  AuthzInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class AuthzInteractor {
    
    public static var shared: AuthzInteractor = AuthzInteractor()
    var sharedService: AuthzServiceWorker
    var sharedPresenter: AuthzPresenter
    
    public init() {
        sharedService = AuthzServiceWorker.shared
        sharedPresenter = AuthzPresenter.shared
    }
    
    // Get Request Id
    public func getRequestId(extraParams: Dictionary<String, String>, callback: @escaping(Result<RequestIdResponseEntity>) -> Void) {
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getRequestId(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getRequestId(extraParams: extraParams, properties: savedProp!) { response, error in
            self.sharedPresenter.getRequestId(response: response, errorResponse: error, callback: callback)
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
