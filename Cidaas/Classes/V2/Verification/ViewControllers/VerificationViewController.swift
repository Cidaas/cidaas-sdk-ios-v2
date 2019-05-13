//
//  VerificationViewController.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import UIKit

public class VerificationViewController {

    public static var shared: VerificationViewController = VerificationViewController()
    
    public func scanned(verificationType: String, incomingData: ScannedRequest, callback: @escaping (Result<ScannedResponse>) -> Void) {
        VerificationInteractor.shared.scanned(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
    
    public func enroll(verificationType: String, incomingData: EnrollRequest, callback: @escaping (Result<EnrollResponse>) -> Void) {
        VerificationInteractor.shared.enroll(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
    
    public func initiate(verificationType: String, incomingData: InitiateRequest, callback: @escaping (Result<InitiateResponse>) -> Void) {
        VerificationInteractor.shared.initiate(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
    
    public func pushAcknowledge(verificationType: String, incomingData: PushAcknowledgeRequest, callback: @escaping (Result<PushAcknowledgeResponse>) -> Void) {
        VerificationInteractor.shared.pushAcknowledge(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
    
    public func pushAllow(verificationType: String, incomingData: PushAllowRequest, callback: @escaping (Result<PushAllowResponse>) -> Void) {
        VerificationInteractor.shared.pushAllow(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
    
    public func pushReject(verificationType: String, incomingData: PushRejectRequest, callback: @escaping (Result<PushRejectResponse>) -> Void) {
        VerificationInteractor.shared.pushReject(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
    
    public func authenticate(verificationType: String, incomingData: AuthenticateRequest, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        VerificationInteractor.shared.authenticate(verificationType: verificationType, incomingData: incomingData, callback: callback)
    }
}
