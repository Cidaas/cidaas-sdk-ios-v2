//
//  Verification.swift
//  Cidaas
//
//  Created by ganesh on 10/05/19.
//

import Foundation

public class Verification {
    
    public init() {}
    
    public func scanned(verificationType: String, scannedRequest: ScannedRequest, callback:@escaping (Result<ScannedResponse>) -> Void) {
        VerificationViewController.shared.scanned(verificationType: verificationType, incomingData: scannedRequest, callback: callback)
    }
    
    public func enroll(verificationType: String, photo: UIImage = UIImage(), voice: Data = Data(), enrollRequest: EnrollRequest, callback:@escaping (Result<EnrollResponse>) -> Void) {
        VerificationViewController.shared.enroll(verificationType: verificationType, photo: photo, voice: voice, incomingData: enrollRequest, callback: callback)
    }
    
    public func pushAcknowledge(verificationType: String, pushAckRequest: PushAcknowledgeRequest, callback:@escaping (Result<PushAcknowledgeResponse>) -> Void) {
        VerificationViewController.shared.pushAcknowledge(verificationType: verificationType, incomingData: pushAckRequest, callback: callback)
    }
    
    public func pushAllow(verificationType: String, pushAllowRequest: PushAllowRequest, callback:@escaping (Result<PushAllowResponse>) -> Void) {
        VerificationViewController.shared.pushAllow(verificationType: verificationType, incomingData: pushAllowRequest, callback: callback)
    }
    
    public func pushReject(verificationType: String, pushRejectRequest: PushRejectRequest, callback:@escaping (Result<PushRejectResponse>) -> Void) {
        VerificationViewController.shared.pushReject(verificationType: verificationType, incomingData: pushRejectRequest, callback: callback)
    }
    
    public func authenticate(verificationType: String, photo: UIImage = UIImage(), voice: Data = Data(), authenticateRequest: AuthenticateRequest, callback:@escaping (Result<AuthenticateResponse>) -> Void) {
        VerificationViewController.shared.authenticate(verificationType: verificationType, photo: photo, voice: voice, incomingData: authenticateRequest, callback: callback)
    }
    
    public func deleteAll(deleteRequest: DeleteRequest, callback:@escaping (Result<DeleteResponse>) -> Void) {
        VerificationViewController.shared.deleteAll(incomingData: deleteRequest, callback: callback)
    }
    
    public func delete(deleteRequest: DeleteRequest, callback:@escaping (Result<DeleteResponse>) -> Void) {
        VerificationViewController.shared.delete(incomingData: deleteRequest, callback: callback)
    }
    
    public func getConfiguredList(mfaListRequest: MFAListRequest, callback:@escaping (Result<MFAListResponse>) -> Void) {
        VerificationViewController.shared.getConfiguredList(incomingData: mfaListRequest, callback: callback)
    }
    
    public func getPendingNotificationList(pendingNotificationRequest: PendingNotificationRequest, callback:@escaping (Result<PendingNotificationResponse>) -> Void) {
        VerificationViewController.shared.getPendingNotificationList(incomingData: pendingNotificationRequest, callback: callback)
    }
    
    public func getAuthenticatedHistoryList(authenticateHistoryRequest: AuthenticatedHistoryRequest, callback:@escaping (Result<AuthenticatedHistoryResponse>) -> Void) {
        VerificationViewController.shared.getAuthenticatedHistoryList(incomingData: authenticateHistoryRequest, callback: callback)
    }
    
    public func updateFCM(push_id: String) {
        VerificationViewController.shared.updateFCM(push_id: push_id)
    }
}
