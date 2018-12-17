//
//  SafariAuthenticationSession.swift
//  Cidaas
//
//  Created by ganesh on 04/12/18.
//

import Foundation
import SafariServices
import AuthenticationServices

@available(iOS 12.0, *)
public class SafariAuthenticationSession : AuthSession {
    
    var authSession: ASWebAuthenticationSession?
    var loginURL: URL
    
    public init(loginURL : URL, redirectURL : URL, callback: @escaping (Result<LoginResponseEntity>) -> ()) {
        self.loginURL = loginURL
        super.init(redirectURL: redirectURL, callback: callback)
        self.authSession = ASWebAuthenticationSession(url: self.loginURL, callbackURLScheme: self.redirectURL.absoluteString, completionHandler: { (resultURL, resultError) in
            guard resultError == nil, let callbackURL = resultURL else {
                if case SFAuthenticationError.canceledLogin = resultError! {
                    callback(Result.failure(error: WebAuthError.shared.userCancelledException()))
                } else {
                    callback(Result.failure(error: WebAuthError.shared.userCancelledException()))
                }
                return TransactionStore.shared.clear()
            }
            _ = TransactionStore.shared.resume(callbackURL, options: [:])
        })
        self.authSession?.start()
    }
}
