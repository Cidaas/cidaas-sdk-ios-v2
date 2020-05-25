//
//  AccountVerificationURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class AccountVerificationURLHelper {
    
    public static var shared : AccountVerificationURLHelper = AccountVerificationURLHelper()
    
    public var initiateAccountVerificationURL = "/verification-srv/account/initiate"
    public var verifyAccountURL = "/verification-srv/account/verify"
    public var verifyAccountListURL = "/users-srv/user/communication/status"
    
    public func getInitiateAccountVerificationURL() -> String {
        return initiateAccountVerificationURL
    }
    
    public func getVerifyAccountURL() -> String {
        return verifyAccountURL
    }
    
    public func getVerifyAccountListURL(sub: String) -> String {
        return verifyAccountListURL + "/" + sub
    }
}
