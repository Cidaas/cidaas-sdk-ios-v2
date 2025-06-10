//
//  LogoutController.swift
//  Cidaas
//
//  Created by Kundan Kishore on 19/11/20.
//

import Foundation
public class LogoutController{
     public static var shared: LogoutController = LogoutController()
    
     var sharedInteractor: LoginInteractor
    
    public init() {
        sharedInteractor = LoginInteractor.shared
    }
    
    // logout service
    // logout with sub
    public func logout(sub : String,  callback: @escaping(Result<Bool>) -> Void) {
        sharedInteractor.logout(sub: sub, callback: callback)
    }
    
    // logout service
    // logout with access_token
    public func logout(access_token : String,  callback: @escaping(Result<Bool>) -> Void) {
        sharedInteractor.logout(access_token: access_token, callback: callback)
    }
}
