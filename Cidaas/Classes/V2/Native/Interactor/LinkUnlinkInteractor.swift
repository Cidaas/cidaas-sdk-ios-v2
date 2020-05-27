//
//  LinkUnlinkInteractor.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LinkUnlinkInteractor {
    
    public static var shared: LinkUnlinkInteractor = LinkUnlinkInteractor()
    var sharedService: LinkUnlinkServiceWorker
    var sharedPresenter: LinkUnlinkPresenter
    
    public init() {
        sharedService = LinkUnlinkServiceWorker.shared
        sharedPresenter = LinkUnlinkPresenter.shared
    }
    
    // link user
    public func linkAccount(access_token: String, incomingData : LinkAccountEntity, callback: @escaping(Result<LinkAccountResponseEntity>) -> Void) {
        
        // validation
        if (incomingData.master_sub == "" || incomingData.sub_to_link == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "master_sub or sub_to_link cannot be empty", statusCode: 417)
            sharedPresenter.linkAccount(response: nil, errorResponse: error, callback: callback)
            return
        }

        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.linkAccount(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.linkAccount(access_token: access_token, incomingData: incomingData, properties: savedProp!) { response, error in
            self.sharedPresenter.linkAccount(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // get linked users
    public func getLinkedUsers(access_token: String, sub: String, callback: @escaping(Result<LinkedUserListResponseEntity>) -> Void) {
        
        // validation
        if (access_token == "" || sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "access_token or sub cannot be empty", statusCode: 417)
            sharedPresenter.getLinkedUsers(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.getLinkedUsers(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.getLinkedUsers(access_token: access_token, sub: sub, properties: savedProp!) { response, error in
            self.sharedPresenter.getLinkedUsers(response: response, errorResponse: error, callback: callback)
        }
    }
    
    // unlink user
    public func unlinkAccount(access_token: String, identityId: String, callback: @escaping(Result<LinkAccountResponseEntity>) -> Void) {
        
        // validation
        if (access_token == "" || identityId == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "access_token or identityId cannot be empty", statusCode: 417)
            sharedPresenter.unlinkAccount(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            sharedPresenter.unlinkAccount(response: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        sharedService.unlinkAccount(access_token: access_token, identityId: identityId, properties: savedProp!) { response, error in
            self.sharedPresenter.unlinkAccount(response: response, errorResponse: error, callback: callback)
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
