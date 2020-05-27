//
//  AccountVerificationViewController.swift
//  Cidaas
//
//  Created by Ganesh on 13/05/20.
//

import Foundation

public class AccountVerificationViewController {
    
    public static var shared: AccountVerificationViewController = AccountVerificationViewController()
    public var sharedInteractor: AccountVerificationInteractor
    
    public init() {
        sharedInteractor = AccountVerificationInteractor.shared
    }
    
    // Account verification
    public func initiateAccountVerification(accountVerificationEntity : InitiateAccountVerificationEntity, callback: @escaping (Result<InitiateAccountVerificationResponseEntity>) -> Void) {
        sharedInteractor.initiateAccountVerification(incomingData: accountVerificationEntity, callback: callback)
    }
    
    public func verifyAccount(accountVerificationEntity : VerifyAccountEntity, callback: @escaping (Result<VerifyAccountResponseEntity>) -> Void) {
        sharedInteractor.verifyAccount(incomingData: accountVerificationEntity, callback: callback)
    }
    
    public func getAccountVerificationList(sub: String, callback: @escaping (Result<AccountVerificationListResponseEntity>) -> Void) {
        sharedInteractor.getAccountVerificationList(sub: sub, callback: callback)
    }
}
