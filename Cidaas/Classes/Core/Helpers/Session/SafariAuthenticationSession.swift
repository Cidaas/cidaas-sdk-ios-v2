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
    
    public init(loginURL : URL, redirectURL : String, callback: @escaping (Result<LoginResponseEntity>) -> ()) {
        self.loginURL = loginURL
        super.init(callback: callback)
        self.authSession = ASWebAuthenticationSession(url: self.loginURL, callbackURLScheme: redirectURL, completionHandler: { (resultURL, resultError) in
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
        
        if #available(iOS 13.0, *) {
            self.authSession?.presentationContextProvider = self
        }
        self.authSession?.start()
    }
}

@available(iOS 13.0, *)
extension SafariAuthenticationSession: ASWebAuthenticationPresentationContextProviding {

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).last ?? ASPresentationAnchor()
    }

}
