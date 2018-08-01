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
    
    public var requestIdURL = "/authz-srv/authrequest/authz/generate"
    
    public var tenantInfoURL = "/public-srv/tenantinfo/basic"
    
    public var clientInfoURL = "/public-srv/public"
    
    public var loginWithCredentialsURL = "/login-srv/login/sdk"
    
    public var consentURL = "/consent-management-srv/tenant/version/pageurl"
    public var consentDetailsURL = "/consent-management-srv/tenant/group/public"
    public var acceptConsentURL = "/consent-management-srv/tenant/user/status"
    
    public var mfaListURL = "/verification-srv/settings/list"
    
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
    
    public var authenticateBackupcodeURL = "/verification-srv/backupcode/authenticate"
    public var authenticateTOTPURL = "/verification-srv/totp/authenticate"
    public var mfaContinueURL = "/login-srv/precheck/continue/sdk"
    public var consentContinueURL = "/login-srv/precheck/continue/sdk"
    public var registrationFieldsURL = "/registration-setup-srv/public/list"
    public var registrationURL = "/users-srv/register"
    public var validateDeviceURL = "/verification-srv/device/validate"
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
    
    public var initiateAccountVerificationURL = "/verification-srv/account/initiate"
    public var verifyAccountURL = "/verification-srv/account/verify"
    
    public var initiateResetPasswordURL = "/users-srv/resetpassword/initiate"
    public var handleResetPasswordURL = "/users-srv/resetpassword/validatecode"
    public var resetPasswordURL = "/users-srv/resetpassword/accept"
    
    public var passwordlessContinueURL = "/login-srv/verification/sdk/login"
    public var userInfoURL = "/users-srv/userinfo"
    
    public var deduplicationDetails = "/users-srv/deduplication/info"
    public var registerDeduplicationURL = "/users-srv/deduplication/register"
    public var loginDeduplicationURL = "/login-srv/login/sdk"
    
    public var changePasswordURL = "/users-srv/changepassword"
    
    public func getRequestIdURL() -> String {
        return requestIdURL
    }
    
    public func getTenantInfoURL() -> String {
        return tenantInfoURL
    }
    
    public func getClientInfoURL(requestId: String) -> String {
        return clientInfoURL + "/" + requestId
    }
    
    public func getLoginWithCredentialsURL() -> String {
        return loginWithCredentialsURL
    }
    
    public func getConsentURL(consent_name: String, version: Int16) -> String {
        return consentURL + "?consent_name=" + consent_name + "&version=" + String(version)
    }
    
    public func getConsentDetailsURL(consent_name: String) -> String {
        return consentDetailsURL + "/" + consent_name
    }
    
    public func getAcceptConsentURL() -> String {
        return acceptConsentURL
    }
    
    public func getMFAListURL(sub: String) -> String {
        return mfaListURL + "?sub=" + sub
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
    
    public func getAuthenticateTOTPURL() -> String {
        return authenticateTOTPURL
    }
    
    public func getMFAContinueURL(trackId: String) -> String {
        return mfaContinueURL + "/" + trackId
    }
    
    public func getPasswordlessContinueURL() -> String {
        return passwordlessContinueURL
    }
    
    public func getConsentContinueURL(trackId: String) -> String {
        return consentContinueURL + "/" + trackId
    }
    
    public func getRegistrationFieldsURL(acceptlanguage: String, requestId: String) -> String {
        return registrationFieldsURL + "?acceptlanguage=" + acceptlanguage + "&requestId=" + requestId
    }
    
    public func getRegistrationURL() -> String {
        return registrationURL
    }
    
    public func getSetupPatternURL() -> String {
        return setupPatternURL
    }
    
    public func getValidateDeviceURL() -> String {
        return validateDeviceURL
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
    
    public func getInitiateAccountVerificationURL() -> String {
        return initiateAccountVerificationURL
    }
    
    public func getVerifyAccountURL() -> String {
        return verifyAccountURL
    }
    
    public func getInitiateResetPasswordURL() -> String {
        return initiateResetPasswordURL
    }
    
    public func getHandleResetPasswordURL() -> String {
        return handleResetPasswordURL
    }
    
    public func getResetPasswordURL() -> String {
        return resetPasswordURL
    }
    
    public func getUserInfoURL() -> String {
        return userInfoURL
    }
    
    public func getDeduplicationDetailsURL(track_id: String) -> String {
        return deduplicationDetails + "/" + track_id
    }
    
    public func getRegisterDeduplicationURL(track_id: String) -> String {
        return registerDeduplicationURL + "/" + track_id
    }
    
    public func getLoginDeduplicationURL() -> String {
        return loginDeduplicationURL
    }
    
    public func getChangePasswordURL() -> String {
        return changePasswordURL
    }
}
