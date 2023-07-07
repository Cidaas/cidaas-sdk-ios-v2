//
//  ResetpasswordURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class ResetpasswordURLHelper {
    
    public static var shared : ResetpasswordURLHelper = ResetpasswordURLHelper()
    
    public var resetPasswordURL = "/password-srv/resetpassword"
    public var initiateResetPasswordURL = "/users-srv/resetpassword/initiate"
    public var handleResetPasswordURL = "/users-srv/resetpassword/validatecode"
    public var acceptResetPasswordURL = "/users-srv/resetpassword/accept"
    
    public func getInitiateResetPasswordURL() -> String {
        return initiateResetPasswordURL
    }
    
    public func getHandleResetPasswordURL() -> String {
        return handleResetPasswordURL
    }
    
    public func getHandleResetPasswordV3URL() -> String {
        return resetPasswordURL + "?action=validatecode"
    }
   
    public func getResetPasswordV3URL() -> String {
        return resetPasswordURL + "?action=acceptreset"
    }
    
    public func getResetPasswordURL() -> String {
        return acceptResetPasswordURL
    }
}
