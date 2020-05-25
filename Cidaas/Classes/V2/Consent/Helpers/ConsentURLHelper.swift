//
//  ConsentURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ConsentURLHelper {
    
    public static var shared : ConsentURLHelper = ConsentURLHelper()
    
    public var consentDetailsURL = "/consent-management-srv/v2/consent/usage/public/info"
    public var acceptConsentURL = "/consent-management-srv/v2/consent/usage/accept"
    public var consentContinueURL = "/login-srv/precheck/continue/sdk"
    
    
    public func getConsentDetailsURL() -> String {
        return consentDetailsURL
    }
    
    public func getAcceptConsentURL() -> String {
        return acceptConsentURL
    }
    
    public func getConsentContinueURL(trackId: String) -> String {
        return consentContinueURL + "/" + trackId
    }
}
