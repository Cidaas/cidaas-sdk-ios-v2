//
//  RegistrationViewController.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class RegistrationViewController {
    
    public static var shared: RegistrationViewController = RegistrationViewController()
    var sharedInteractor: RegistrationInteractor
    
    public init() {
        sharedInteractor = RegistrationInteractor.shared
    }
    
    // Get registration fields
    public func getRegistrationFields(acceptlanguage: String, requestId: String, callback: @escaping(Result<RegistrationFieldsResponseEntity>) -> Void) {
        sharedInteractor.getRegistrationFields(acceptlanguage: acceptlanguage, requestId: requestId, callback: callback)
    }
    
    // Register user
    public func registerUser(requestId: String, incomingData: RegistrationEntity, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        sharedInteractor.registerUser(requestId: requestId, incomingData: incomingData, callback: callback)
    }
    
    // update user service
    public func updateUser(access_token: String, incomingData: RegistrationEntity, callback: @escaping(Result<UpdateUserResponseEntity>) -> Void) {
        sharedInteractor.updateUser(access_token: access_token, incomingData: incomingData, callback: callback)
    }
}
