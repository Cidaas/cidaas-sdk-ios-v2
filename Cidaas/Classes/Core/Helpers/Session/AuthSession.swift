//
//  AuthSession.swift
//  Cidaas
//
//  Created by ganesh on 04/12/18.
//

import Foundation

public class AuthSession: NSObject, OAuthTransactionDelegate {
    
    public var state: String?
    var redirectURL : URL
    let callback : (Result<LoginResponseEntity>) -> ()
    
    public init(redirectURL: URL, state: String? = nil, callback: @escaping (Result<LoginResponseEntity>) -> ()) {
        self.state = state
        self.redirectURL = redirectURL
        self.callback = callback
        super.init()
    }
    
    public func resume(_ url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }
    
    public func cancel() {
        // return error
    }
}
