//
//  ResetPasswordViewController.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ResetPasswordViewController {
    
    public static var shared: ResetPasswordViewController = ResetPasswordViewController()
    var sharedInteractor: ResetPasswordInteractor
    
    public init() {
        sharedInteractor = ResetPasswordInteractor.shared
    }
    
    // Initiate reset password
    public func initiateResetPassword(incomingData : InitiateResetPasswordEntity, callback: @escaping(Result<InitiateResetPasswordResponseEntity>) -> Void) {
        sharedInteractor.initiateResetPassword(incomingData: incomingData, callback: callback)
    }
    
    // Handle reset password
    public func handleResetPassword(incomingData : HandleResetPasswordEntity, callback: @escaping(Result<HandleResetPasswordResponseEntity>) -> Void) {
        sharedInteractor.handleResetPassword(incomingData: incomingData, callback: callback)
    }
    
    // reset password
    public func resetPassword(incomingData : ResetPasswordEntity, callback: @escaping(Result<ResetPasswordResponseEntity>) -> Void) {
        sharedInteractor.resetPassword(incomingData: incomingData, callback: callback)
    }
}
