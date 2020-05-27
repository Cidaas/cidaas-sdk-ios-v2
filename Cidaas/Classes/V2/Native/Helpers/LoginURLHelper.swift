//
//  LoginURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LoginURLHelper {
    
    public static var shared : LoginURLHelper = LoginURLHelper()
    
    public var loginWithCredentialsURL = "/login-srv/login/sdk"
    
    public func getLoginWithCredentialsURL() -> String {
        return loginWithCredentialsURL
    }
}
