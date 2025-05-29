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
    var accessToken = ""
  
    
    public init() {
        sharedService = LoginServiceWorker.shared
        sharedPresenter = LoginPresenter.shared
    }
    
    // login with credentials service
    public func loginWithCredentials(incomingData : LoginEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        // validation  //
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
    
    public func logout(access_token : String, callback: @escaping(Result<Bool>) -> Void){
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.logout(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // check if access_token is empty
        if (access_token.isEmpty) {
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "access_token cannot be empty", statusCode: 417)
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call get user info service
        UsersService.shared.getUserInfo(accessToken: access_token, properties: savedProp!) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "User-Info service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let userInfoResponse):
                // log success
                let loggerMessage = "User-Info service success : " + "Email  - " + String(describing: userInfoResponse.email)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // call worker
                self.sharedService.logout(access_token : access_token, properties: savedProp!) { response, error in
                    if error == nil {
                        // remove user data if logout is success
                        UserDefaults.standard.removeObject(forKey: "cidaas_user_details_\(userInfoResponse.sub)")
                    }
                    self.sharedPresenter.logout(response: response, errorResponse: error, callback: callback)
                    
                }
                
            }
        }
        
    }

    
    public func logout(sub : String,  callback: @escaping(Result<Bool>) -> Void){
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.logout(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // check if sub is empty
        if (sub.isEmpty) {
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        
        // get access_token using sub
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .success(result: let result):
                // call worker
                self.sharedService.logout(access_token : result.data.access_token, properties: savedProp!) { response, error in
                    if error == nil {
                        // remove user data if logout is success
                        UserDefaults.standard.removeObject(forKey: "cidaas_user_details_\(sub)")
                    }
                    self.sharedPresenter.logout(response: response, errorResponse: error, callback: callback)
                }
            case .failure(error: let error):
                // return callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
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
