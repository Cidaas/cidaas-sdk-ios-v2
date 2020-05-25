//
//  AuthzViewController.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class AuthzViewController {
    
    public static var shared: AuthzViewController = AuthzViewController()
    var sharedInteractor: AuthzInteractor
    
    public init() {
        sharedInteractor = AuthzInteractor.shared
    }
    
    // Get Request Id
    public func getRequestId(extraParams: Dictionary<String, String>, callback: @escaping(Result<RequestIdResponseEntity>) -> Void) {
        sharedInteractor.getRequestId(extraParams: extraParams, callback: callback)
    }
}
