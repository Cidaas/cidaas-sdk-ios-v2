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
public class SafariLogoutSession: NSObject {
    
    var authSession: ASWebAuthenticationSession?
    var logoutURL: URL
    var callback: (Result<Bool>) -> Void
    
    public init(logoutURL: URL, redirectURL: String, callback: @escaping (Result<Bool>) -> Void) {
        self.logoutURL = logoutURL
        self.callback = callback
        
        super.init()
        
        let arrayOfURL = redirectURL.components(separatedBy: "://")
        var shortRedirectURL = redirectURL
        if arrayOfURL.count > 0 {
            shortRedirectURL = arrayOfURL[0]
        }
        
        self.authSession = ASWebAuthenticationSession(url: self.logoutURL, callbackURLScheme: shortRedirectURL,
                                                      completionHandler: { (resultURL, resultError) in
            // Clear stored credentials/tokens
            TransactionStore.shared.clear()
            
            if let error = resultError {
                
                // For logout, treat cancellation as success
                if case ASWebAuthenticationSessionError.canceledLogin = error {
                    callback(Result.success(result: true))
                } else {
                    print("Logout error: \(error.localizedDescription)")
                    // completion(false)
                    callback(Result.failure(error: WebAuthError.shared.logoutWithBrowserFailureException()))
                }
                return
            }
            
            // Successfully logged out
            callback(Result.success(result: true))
        })
        
        if #available(iOS 13.0, *) {
            self.authSession?.presentationContextProvider = self
        }
        self.authSession?.start()
    }
}

@available(iOS 13.0, *)
extension SafariLogoutSession: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.filter({ $0.isKeyWindow }).last ?? ASPresentationAnchor()
    }
}
