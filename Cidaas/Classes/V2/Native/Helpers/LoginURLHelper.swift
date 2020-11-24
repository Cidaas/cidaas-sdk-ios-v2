//
//  LoginURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LoginURLHelper {
    
    public static var shared : LoginURLHelper = LoginURLHelper()
    public var logoutURL = "/session/end_session"
    public var loginWithCredentialsURL = "/login-srv/login/sdk"
    
    public func getLoginWithCredentialsURL() -> String {
        return loginWithCredentialsURL
    }
    
    public func getLogout(accessToken : String) -> String {
        return logoutURL + "?access_token_hint=" + accessToken
    }
}
