//
//  AuthzURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class AuthzURLHelper {
    
    public static var shared : AuthzURLHelper = AuthzURLHelper()
    
    public var authzURL = "/authz-srv/authrequest/authz/generate"
    
    public func getAuthzURL() -> String {
        return authzURL
    }
}
