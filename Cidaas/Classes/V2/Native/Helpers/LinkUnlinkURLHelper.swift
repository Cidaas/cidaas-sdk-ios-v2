//
//  LinkUnlinkURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LinkUnlinkURLHelper {
    
    public static var shared : LinkUnlinkURLHelper = LinkUnlinkURLHelper()
    
    public var linkUserURL = "/users-srv/user/linkaccount"
    public var linkedUsersURL = "/users-srv/userinfo/social"
    public var unlinkUserURL = "/users-srv/user/unlinkaccount"
    
    public func getLinkUserURL() -> String {
        return linkUserURL
    }
    
    public func getUnlinkUserURL(identityId: String) -> String {
        return unlinkUserURL + "/" + identityId
    }
    
    public func getLinkedUsersListURL(sub: String) -> String {
        return linkedUsersURL + "/" + sub
    }
}
