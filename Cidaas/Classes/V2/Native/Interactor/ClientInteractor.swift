//
//  ClientInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class ClientInteractor {
    
    public static var shared: ClientInteractor = ClientInteractor()
    var sharedService: ClientServiceWorker
    var sharedPresenter: ClientPresenter
    
    public init() {
        sharedService = ClientServiceWorker.shared
        sharedPresenter = ClientPresenter.shared
    }
    
    // Client Info
    public func getClientInfo(requestId: String, callback: @escaping(Result<ClientInfoResponseEntity>) -> Void) {
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getClientInfo(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getClientInfo(requestId: requestId, properties: savedProp!) { response, error in
            self.sharedPresenter.getClientInfo(response: response, errorResponse: error, callback: callback)
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
