//
//  URLHelper.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class URLHelper {
    
    // shared instance
    public static var shared : URLHelper = URLHelper()
    
    
    public var logoutURL = "/session/end_session"
    
    public var consentURL = "/consent-management-srv/tenant/version/pageurl"
    public var consentDetailsURL = "/consent-management-srv/settings/public"
    
    public var mfaListURL = "/verification-srv/settings/listbydeviceid"
    
    public var initiateEmailURL = "/verification-srv/email/initiate"
    public var setupEmailURL = "/verification-srv/email/setup"
    public var enrollEmailURL = "/verification-srv/email/enroll"
    public var authenticateEmailURL = "/verification-srv/email/authenticate"
    
    public var initiateSMSURL = "/verification-srv/sms/initiate"
    public var setupSMSURL = "/verification-srv/sms/setup"
    public var enrollSMSURL = "/verification-srv/sms/enroll"
    public var authenticateSMSURL = "/verification-srv/sms/authenticate"
    
    public var initiateIVRURL = "/verification-srv/ivr/initiate"
    public var setupIVRURL = "/verification-srv/ivr/setup"
    public var enrollIVRURL = "/verification-srv/ivr/enroll"
    public var authenticateIVRURL = "/verification-srv/ivr/authenticate"
    
    public var setupBackupcodeURL = "/verification-srv/backupcode/setup"
    public var initiateBackupcodeURL = "/verification-srv/backupcode/initiate"
    public var initiateTOTPURL = "/verification-srv/totp/initiate"
    public var scannedTOTPURL = "/verification-srv/totp/scanned"
    public var setupTOTPURL = "/verification-srv/totp/setup"
    public var enrollTOTPURL = "/verification-srv/totp/enroll"
    
    public var deleteVerificationURL = "/verification-srv/settings/delete/"
    public var deleteAllVerificationURL = "/verification-srv/settings/deleteall/"
    
    public var authenticateBackupcodeURL = "/verification-srv/backupcode/authenticate"
    public var authenticateTOTPURL = "/verification-srv/totp/authenticate"
    public var mfaContinueURL = "/login-srv/precheck/continue/sdk"
    
    public var setupPatternURL = "/verification-srv/pattern/setup"
    public var scannedPatternURL = "/verification-srv/pattern/scanned"
    public var enrollPatternURL = "/verification-srv/pattern/enroll"
    public var initiatePatternURL = "/verification-srv/pattern/initiate"
    public var authenticatePatternURL = "/verification-srv/pattern/authenticate"
    public var setupTouchIdURL = "/verification-srv/touchid/setup"
    public var scannedTouchIdURL = "/verification-srv/touchid/scanned"
    public var enrollTouchIdURL = "/verification-srv/touchid/enroll"
    public var initiateTouchIdURL = "/verification-srv/touchid/initiate"
    public var authenticateTouchIdURL = "/verification-srv/touchid/authenticate"
    public var setupPushURL = "/verification-srv/push/setup"
    public var scannedPushURL = "/verification-srv/push/scanned"
    public var enrollPushURL = "/verification-srv/push/enroll"
    public var initiatePushURL = "/verification-srv/push/initiate"
    public var authenticatePushURL = "/verification-srv/push/authenticate"
    public var setupFaceURL = "/verification-srv/face/setup"
    public var scannedFaceURL = "/verification-srv/face/scanned"
    public var enrollFaceURL = "/verification-srv/face/enroll"
    public var initiateFaceURL = "/verification-srv/face/initiate"
    public var authenticateFaceURL = "/verification-srv/face/authenticate"
    public var setupVoiceURL = "/verification-srv/voice/setup"
    public var scannedVoiceURL = "/verification-srv/voice/scanned"
    public var enrollVoiceURL = "/verification-srv/voice/enroll"
    public var initiateVoiceURL = "/verification-srv/voice/initiate"
    public var authenticateVoiceURL = "/verification-srv/voice/authenticate"
    
    
    public var passwordlessContinueURL = "/login-srv/verification/sdk/login"
    public var userInfoURL = "/users-srv/userinfo"
    
    public var documentScanURL = "/access-control-srv/ocr/validate"
    
    public var userLoginInfoURL = "/verification-srv/verificationstatus/status/search/sdk"
    public var imageUploadURL = "/image-srv/profile/upload"
    
    public var locationEmissionURL = "/access-control-srv/notification/locationchange"
    public var beaconListURL = "/access-control-srv/devices/beacons/configs"
    public var beaconEmissionURL = "/access-control-srv/notification/beaconemit"
    public var socialURL = "/login-srv/social/token"
    public var endpointsURL = "/.well-known/openid-configuration"
    public var denyRequestURL = "/verification-srv/notification/reject"
    public var updateFCMTokenURL = "/devices-srv/device/updatefcm"
    public var pendingNotificationListURL = "/verification-srv/notification/initiated"
    public var socialLoginURL = "/login-srv/social/login/"
    
    
    public func getEndpointsURL() -> String {
        return endpointsURL
    }
    
    public func getDenyRequestURL() -> String {
        return denyRequestURL
    }
    
    public func getUpdateFCMTokenURL() -> String {
        return updateFCMTokenURL
    }
    
    public func getPendingNotificationListURL(userDeviceId: String) -> String {
        return pendingNotificationListURL + "/" + userDeviceId
    }
    
    public func getBeaconListURL() -> String {
        return beaconListURL
    }
    
    public func getLocationEmissionURL() -> String {
        return locationEmissionURL
    }
    
    public func getBeaconEmissionURL() -> String {
        return beaconEmissionURL
    }
    
    
    
    public func getLogoutURL(accessToken: String) -> String {
        return logoutURL + "?access_token_hint=" + accessToken
    }
    
    public func getConsentURL(consent_name: String, version: Int16) -> String {
        return consentURL + "?consent_name=" + consent_name + "&version=" + String(version)
    }
    
    public func getSocialLoginURL(provider: String, requestId: String) -> String {
        return socialLoginURL + provider + "/" + requestId
    }
    
    public func getMFAListURL(sub: String, userDeviceId: String, common_config: Bool) -> String {
        
        if (common_config == false) {
            return "\(mfaListURL)?sub=\(sub)&userDeviceId=\(userDeviceId)"
        }
        return "\(mfaListURL)?sub=\(sub)&userDeviceId=\(userDeviceId)&common_configs=\(common_config)"
    }
    
    public func getSetupEmailURL() -> String {
        return setupEmailURL
    }
    
    public func getInitiateEmailURL() -> String {
        return initiateEmailURL
    }
    
    public func getEnrollEmailURL() -> String {
        return enrollEmailURL
    }
    
    public func getSetupSMSURL() -> String {
        return setupSMSURL
    }
    
    public func getEnrollSMSURL() -> String {
        return enrollSMSURL
    }
    
    public func getInitiateSMSURL() -> String {
        return initiateSMSURL
    }
    
    public func getSetupIVRURL() -> String {
        return setupIVRURL
    }
    
    public func getEnrollIVRURL() -> String {
        return enrollIVRURL
    }
    
    public func getInitiateIVRURL() -> String {
        return initiateIVRURL
    }
    
    public func getSetupBackupcodeURL() -> String {
        return setupBackupcodeURL
    }
    
    public func getInitiateBackupcodeURL() -> String {
        return initiateBackupcodeURL
    }
    
    public func getInitiateTOTPURL() -> String {
        return initiateTOTPURL
    }
    
    public func getSetupTOTPURL() -> String {
        return setupTOTPURL
    }
    
    public func getEnrollTOTPURL() -> String {
        return enrollTOTPURL
    }
    
    public func getScannedTOTPURL() -> String {
        return scannedTOTPURL
    }
    
    public func getAuthenticateEmailURL() -> String {
        return authenticateEmailURL
    }
    
    public func getAuthenticateSMSURL() -> String {
        return authenticateSMSURL
    }
    
    public func getAuthenticateIVRURL() -> String {
        return authenticateIVRURL
    }
    
    public func getAuthenticateBackupcodeURL() -> String {
        return authenticateBackupcodeURL
    }
    
    public func getDeleteVerificationURL(userDeviceId: String, verificationType: String) -> String {
        return deleteVerificationURL + userDeviceId + "/" + verificationType.uppercased()
    }
    
    public func getDeleteAllVerificationURL(userDeviceId: String) -> String {
        return deleteAllVerificationURL + userDeviceId
    }
    
    public func getAuthenticateTOTPURL() -> String {
        return authenticateTOTPURL
    }
    
    public func getMFAContinueURL(trackId: String) -> String {
        return mfaContinueURL + "/" + trackId
    }
    
    public func getPasswordlessContinueURL() -> String {
        return passwordlessContinueURL
    }
    
    
    public func getSetupPatternURL() -> String {
        return setupPatternURL
    }
    
    public func getScannedPatternURL() -> String {
        return scannedPatternURL
    }
    
    public func getEnrollPatternURL() -> String {
        return enrollPatternURL
    }
    
    public func getInitiatePatternURL() -> String {
        return initiatePatternURL
    }
    
    public func getAuthenticatePatternURL() -> String {
        return authenticatePatternURL
    }
    
    public func getSetupTouchIdURL() -> String {
        return setupTouchIdURL
    }
    public func getScannedTouchIdURL() -> String {
        return scannedTouchIdURL
    }
    
    public func getEnrollTouchIdURL() -> String {
        return enrollTouchIdURL
    }
    
    public func getInitiateTouchIdURL() -> String {
        return initiateTouchIdURL
    }
    
    public func getAuthenticateTouchIdURL() -> String {
        return authenticateTouchIdURL
    }
    
    public func getSetupPushURL() -> String {
        return setupPushURL
    }
    public func getScannedPushURL() -> String {
        return scannedPushURL
    }
    
    public func getEnrollPushURL() -> String {
        return enrollPushURL
    }
    
    public func getInitiatePushURL() -> String {
        return initiatePushURL
    }
    
    public func getAuthenticatePushURL() -> String {
        return authenticatePushURL
    }
    
    public func getSetupFaceURL() -> String {
        return setupFaceURL
    }
    public func getScannedFaceURL() -> String {
        return scannedFaceURL
    }
    
    public func getEnrollFaceURL() -> String {
        return enrollFaceURL
    }
    
    public func getInitiateFaceURL() -> String {
        return initiateFaceURL
    }
    
    public func getAuthenticateFaceURL() -> String {
        return authenticateFaceURL
    }
    
    public func getSetupVoiceURL() -> String {
        return setupVoiceURL
    }
    public func getScannedVoiceURL() -> String {
        return scannedVoiceURL
    }
    
    public func getEnrollVoiceURL() -> String {
        return enrollVoiceURL
    }
    
    public func getInitiateVoiceURL() -> String {
        return initiateVoiceURL
    }
    
    public func getAuthenticateVoiceURL() -> String {
        return authenticateVoiceURL
    }    
    
    
    public func getUserInfoURL() -> String {
        return userInfoURL
    }

    
    public func getUserLoginInfoURL() -> String {
        return userLoginInfoURL
    }
    
    
    public func getDocumentScanURL() -> String {
        return documentScanURL
    }
    
    public func getImageUploadURL() -> String {
        return imageUploadURL
    }
    
    
    public func getSocialURL(requestId: String, socialToken: String, provider: String, clientId: String, redirectURL: String, viewType: String) -> String {
        return "\(socialURL)?codeOrToken=\(socialToken)&provider=\(provider)&clientId=\(clientId)&givenType=token&responseType=code&redirectUrl=\(redirectURL)&viewtype=\(viewType)&preAuthCode=\(requestId)"
    }
}
