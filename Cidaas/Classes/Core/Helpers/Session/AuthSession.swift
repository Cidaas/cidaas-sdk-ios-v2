//
//  AuthSession.swift
//  Cidaas
//
//  Created by ganesh on 04/12/18.
//

import Foundation
import UIKit

public class AuthSession<T>: NSObject, OAuthTransactionDelegate {
    
    public var state: String?
    let callback : (Result<T>) -> ()
    
    public init(state: String? = nil, callback: @escaping (Result<T>) -> ()) {
        self.state = state
        self.callback = callback
        super.init()
    }
    
    public func resume(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Cidaas.shared.handleToken(url: url)
        return true
    }
    
    public func cancel() {
        // return error
        self.callback(Result.failure(error: WebAuthError.shared.userCancelledException()))
    }
}
