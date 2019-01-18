//
//  CidaasFacebook.swift
//  Cidaas
//
//  Created by ganesh on 17/01/19.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKCoreKit

public class CidaasFacebook {
    
    public static var shared : CidaasFacebook = CidaasFacebook()
    
    let loginManager : LoginManager = LoginManager()
    public var delegate: UIViewController!
    
    public func login(viewType: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        
        loginManager.logIn(readPermissions: [.email], viewController: delegate) { (loginResult) in
            switch loginResult {
            case .cancelled:
                callback(Result.failure(error: WebAuthError.shared.userCancelledException()))
                break
            case .failed:
                callback(Result.failure(error: WebAuthError.shared.userCancelledException()))
                break
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                if AccessToken.current != nil {
                    Cidaas.shared.getAccessToken(socialToken: AccessToken.current?.authenticationToken ?? "", provider: "facebook", viewType: viewType, callback: callback)
                }
                else {
                    callback(Result.failure(error: WebAuthError.shared.userCancelledException()))
                }
                
                break
            }
        }
    }
    
    public func logout() {
        loginManager.logOut()
    }
    
    public init() {
        
    }
}
