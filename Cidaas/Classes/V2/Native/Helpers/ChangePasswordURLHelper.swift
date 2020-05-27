//
//  ChangePasswordURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ChangePasswordURLHelper {
    
    public static var shared : ChangePasswordURLHelper = ChangePasswordURLHelper()
    
    public var changePasswordURL = "/users-srv/changepassword"
    
    public func getChangePasswordURL() -> String {
        return changePasswordURL
    }
}
