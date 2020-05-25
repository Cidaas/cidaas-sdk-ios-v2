//
//  TenantInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class TenantInteractor {
    
    public static var shared: TenantInteractor = TenantInteractor()
    var sharedService: TenantServiceWorker
    var sharedPresenter: TenantPresenter
    
    public init() {
        sharedService = TenantServiceWorker.shared
        sharedPresenter = TenantPresenter.shared
    }
    
    // Tenant Info
    public func getTenantInfo(callback: @escaping(Result<TenantInfoResponseEntity>) -> Void) {
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getTenantInfo(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getTenantInfo(properties: savedProp!) { response, error in
            self.sharedPresenter.getTenantInfo(response: response, errorResponse: error, callback: callback)
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
