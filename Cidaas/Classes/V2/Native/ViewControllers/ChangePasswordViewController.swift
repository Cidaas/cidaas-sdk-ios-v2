//
//  ChangePasswordViewController.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ChangePasswordViewController {
    
    public static var shared: ChangePasswordViewController = ChangePasswordViewController()
    var sharedInteractor: ChangePasswordInteractor
    
    public init() {
        sharedInteractor = ChangePasswordInteractor.shared
    }
    
    // Change password
    public func changePassword(access_token: String, incomingData : ChangePasswordEntity, callback: @escaping(Result<ChangePasswordResponseEntity>) -> Void) {
        sharedInteractor.changePassword(access_token: access_token, incomingData: incomingData, callback: callback)
    }
}
