//
//  VerificationURLHelper.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class VerificationURLHelper {
    
    public static var shared : VerificationURLHelper = VerificationURLHelper()
    
    public var scannedURL: String = "/verification-srv/v2/setup/scan/"
    public var enrolledURL: String = "/verification-srv/v2/setup/enroll/"
    public var initiateURL: String = "/verification-srv/v2/authenticate/initiate/"
    public var pushAckURL: String = "/verification-srv/v2/authenticate/push_acknowledge/"
    public var pushAllowURL: String = "/verification-srv/v2/authenticate/allow/"
    public var pushRejectURL: String = "/verification-srv/v2/authenticate/reject/"
    public var authenticateURL: String = "/verification-srv/v2/authenticate/authenticate/"
    public var deleteAllURL: String = "/verification-srv/v2/setup/remove/bydeviceid/"
    public var deleteURL: String = "/verification-srv/v2/setup/remove/bysub/"
    
    public func getScannedURL(verificationType: String) -> String {
        return scannedURL + verificationType
    }
    
    public func getEnrolledURL(verificationType: String) -> String {
        return enrolledURL + verificationType
    }
    
    public func getInitiateURL(verificationType: String) -> String {
        return initiateURL + verificationType
    }
    
    public func getPushAcknowledgeURL(verificationType: String) -> String {
        return pushAckURL + verificationType
    }
    
    public func getPushAllowURL(verificationType: String) -> String {
        return pushAllowURL + verificationType
    }
    
    public func getPushRejectURL(verificationType: String) -> String {
        return pushRejectURL + verificationType
    }
    
    public func getAuthenticateURL(verificationType: String) -> String {
        return authenticateURL + verificationType
    }
    
    public func getDeleteAllURL(deviceId: String) -> String {
        return deleteAllURL + deviceId
    }
    
    public func getDeleteURL(verificationType: String, sub: String) -> String {
        return deleteURL + verificationType + "/" + sub
    }
}
