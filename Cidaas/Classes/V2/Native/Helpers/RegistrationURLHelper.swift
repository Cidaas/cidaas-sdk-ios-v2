//
//  RegistrationURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class RegistrationURLHelper {
    
    public static var shared : RegistrationURLHelper = RegistrationURLHelper()
    
    public var registrationFieldsURL = "/registration-setup-srv/public/list"
    public var registrationURL = "/users-srv/register"
    public var updateUserURL = "/users-srv/user/profile"
    
    public func getRegistrationFieldsURL(acceptlanguage: String, requestId: String) -> String {
        return registrationFieldsURL + "?acceptlanguage=" + acceptlanguage + "&requestId=" + requestId
    }
    
    public func getRegistrationURL() -> String {
        return registrationURL
    }
    
    public func getUpdateUserURL(sub: String) -> String {
        return updateUserURL + "/" + sub
    }
}
