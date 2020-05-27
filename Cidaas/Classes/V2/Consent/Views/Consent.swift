//
//  Consent.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

//
//  Native.swift
//  Cidaas
//
//  Created by Ganesh on 13/05/20.
//

import Foundation

public class CidaasConsent {
    public static var shared: CidaasConsent = CidaasConsent()
    var sharedViewController: ConsentViewController
    
    public init() {
        sharedViewController = ConsentViewController.shared
    }
    
    // get consent details
    public func getConsentDetails(incomingData : ConsentDetailsRequestEntity, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
        sharedViewController.getConsentDetails(incomingData: incomingData, callback: callback)
    }
    
    // accept consent
    public func acceptConsent(incomingData: AcceptConsentEntity, callback: @escaping(Result<AcceptConsentResponseEntity>) -> Void) {
        sharedViewController.acceptConsent(incomingData: incomingData, callback: callback)
    }
    
    // consent continue service
    public func consentContinue(incomingData: ConsentContinueEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        sharedViewController.consentContinue(incomingData: incomingData, callback: callback)
    }
}
