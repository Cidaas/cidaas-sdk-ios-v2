//
//  LinkUnlinkViewController.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LinkUnlinkViewController {
    
    public static var shared: LinkUnlinkViewController = LinkUnlinkViewController()
    var sharedInteractor: LinkUnlinkInteractor
    
    public init() {
        sharedInteractor = LinkUnlinkInteractor.shared
    }
    
    // link user
    public func linkAccount(access_token: String, incomingData : LinkAccountEntity, callback: @escaping(Result<LinkAccountResponseEntity>) -> Void) {
        sharedInteractor.linkAccount(access_token: access_token, incomingData: incomingData, callback: callback)
    }
    
    // get linked users
    public func getLinkedUsers(access_token: String, sub: String, callback: @escaping(Result<LinkedUserListResponseEntity>) -> Void) {
        sharedInteractor.getLinkedUsers(access_token: access_token, sub: sub, callback: callback)
    }
    
    // unlink user
    public func unlinkAccount(access_token: String, identityId: String, callback: @escaping(Result<LinkAccountResponseEntity>) -> Void) {
        sharedInteractor.unlinkAccount(access_token: access_token, identityId: identityId, callback: callback)
    }
}
