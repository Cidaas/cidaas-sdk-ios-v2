//
//  LoginInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LoginInteractor {
    
    public static var shared: LoginInteractor = LoginInteractor()
    var sharedService: LoginServiceWorker
    var sharedPresenter: LoginPresenter
    
    public init() {
        sharedService = LoginServiceWorker.shared
        sharedPresenter = LoginPresenter.shared
    }
    
    // login with credentials service
    public func loginWithCredentials(incomingData : LoginEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.username == "" || incomingData.password == "" || incomingData.username_type == "" || incomingData.requestId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "username or password or username_type or requestId cannot be empty", statusCode: 417)
            sharedPresenter.loginWithCredentials(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.loginWithCredentials(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.loginWithCredentials(incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.loginWithCredentials(response: response, errorResponse: error, callback: callback)
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
