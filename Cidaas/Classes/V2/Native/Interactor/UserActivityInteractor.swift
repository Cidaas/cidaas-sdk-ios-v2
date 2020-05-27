//
//  UserActivityInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class UserActivityInteractor {
    
    public static var shared: UserActivityInteractor = UserActivityInteractor()
    var sharedService: UserActivityServiceWorker
    var sharedPresenter: UserActivityPresenter
    
    public init() {
        sharedService = UserActivityServiceWorker.shared
        sharedPresenter = UserActivityPresenter.shared
    }
    
    // Get Useractivity
    public func getUserActivity(accessToken : String, incomingData: UserActivityEntity, callback: @escaping(Result<UserActivityResponseEntity>) -> Void) {
        
        // validation
        if (accessToken == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "accessToken or sub cannot be empty", statusCode: 417)
            sharedPresenter.getUserActivity(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getUserActivity(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getUserActivity(accessToken: accessToken, incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.getUserActivity(response: response, errorResponse: error, callback: callback)
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
