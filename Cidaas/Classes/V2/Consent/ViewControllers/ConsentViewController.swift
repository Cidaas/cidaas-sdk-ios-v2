//
//  ConsentViewController.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class ConsentViewController {
    
    public static var shared: ConsentViewController = ConsentViewController()
    var sharedInteractor: ConsentInteractor
    
    public init() {
        sharedInteractor = ConsentInteractor.shared
    }
    
    // get consent details
    public func getConsentDetails(incomingData : ConsentDetailsRequestEntity, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
        sharedInteractor.getConsentDetails(incomingData: incomingData, callback: callback)
    }
    
    // accept consent
    public func acceptConsent(incomingData: AcceptConsentEntity, callback: @escaping(Result<AcceptConsentResponseEntity>) -> Void) {
        sharedInteractor.acceptConsent(incomingData: incomingData, callback: callback)
    }
    
    // consent continue service
    public func consentContinue(incomingData: ConsentContinueEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        sharedInteractor.consentContinue(incomingData: incomingData, callback: callback)
    }
}
