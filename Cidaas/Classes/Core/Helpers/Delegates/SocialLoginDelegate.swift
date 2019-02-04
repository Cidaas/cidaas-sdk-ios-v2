//
//  SocialLoginDelegate.swift
//  Cidaas
//
//  Created by ganesh on 21/01/19.
//

import Foundation

public protocol CidaasFacebookDelegate {
    func login(viewType: String, callback: @escaping(Result<LoginResponseEntity>) -> Void)
    func logout()
}

public protocol CidaasGoogleDelegate {
    func login(viewType: String, callback: @escaping(Result<LoginResponseEntity>) -> Void)
    func logout()
}
