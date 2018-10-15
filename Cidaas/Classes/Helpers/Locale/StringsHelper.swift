//
//  StringsHelper.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class StringsHelper {
    
    // shared instance
    public static var shared : StringsHelper = StringsHelper()
    
    // local string variables
    public var DEFAULT : String = "Error Occured."
    public var FILE_NOT_FOUND : String = "Property file is missing."
    public var NO_CONTENT_IN_FILE : String = "No content in property file."
    public var PROPERTY_MISSING : String = "One of the properties are missing."
    public var CONVERSION_EXCEPTION : String = "Error during conversion"
    public var REQUEST_ID_SERVICE_FAILURE : String = "Request Id service failure."
    public var ACCESS_TOKEN_SERVICE_FAILURE : String = "Access token service failure."
    public var EMPTY_REQUEST_ID_SERVICE : String = "Request Id is empty."
    public var EMPTY_LOGIN_URL_SERVICE : String = "Login URL is empty."
    public var EMPTY_LOGIN_URL : String = "Login URL is empty."
    public var EMPTY_REDIRECT_URL : String = "Redirect URL is empty."
    public var EMPTY_DELEGATE : String = "Delegate is empty."
    public var USER_CANCELLED_LOGIN : String = "User cancelled."
    public var CODE_NOT_FOUND : String = "Code not found in URL."
    public var ERROR_JSON_PARSING : String = "Error on JSON parsing."
    public var USER_INFO_SERVICE_FAILURE : String = "User Info service failure."
    public var EMPTY_CALLBACK : String = "Callback is empty."
    public var NO_USER_FOUND : String = "No user found."
    public var REFRESH_TOKEN_SERVICE_FAILURE : String = "Refresh token service failure."
    public var EMPTY_TENANT_INFO_SERVICE: String = "Tenant Info is empty"
    public var TENANT_INFO_SERVICE_FAILURE : String = "Tenant Info service failure"
    public var EMPTY_CLIENT_INFO_SERVICE: String = "Tenant Info is empty"
    public var CLIENT_INFO_SERVICE_FAILURE : String = "Tenant Info service failure"
    public var EMPTY_LOGIN_WITH_CREDENTIAL_SERVICE: String = "Tenant Info is empty"
    public var LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE : String = "Tenant Info service failure"
    public var EMPTY_CONSENT_URL_SERVICE: String = "Consent URL is empty"
    public var CONSENT_URL_SERVICE_FAILURE : String = "Consent URL service failure"
    public var EMPTY_CONSENT_DETAILS_SERVICE: String = "Consent Details is empty"
    public var CONSENT_DETAILS_SERVICE_FAILURE : String = "Consent Details service failure"
    public var EMPTY_ACCEPT_CONSENT_SERVICE: String = "Accept Consent is empty"
    public var ACCEPT_CONSENT_SERVICE_FAILURE : String = "Accept Consent service failure"
    public var EMPTY_MFA_LIST_SERVICE : String = "MFA List is empty"
    public var MFA_LIST_SERVICE_FAILURE : String = "MFA List service failure"
    public var EMPTY_INITIATE_EMAIL_SERVICE : String = "Initiate Email is empty"
    public var INITIATE_EMAIL_SERVICE_FAILURE : String = "Initiate Email service failure"
    public var EMPTY_INITIATE_SMS_SERVICE : String = "Initiate SMS is empty"
    public var INITIATE_SMS_SERVICE_FAILURE : String = "Initiate SMS service failure"
    public var EMPTY_INITIATE_IVR_SERVICE : String = "Initiate IVR is empty"
    public var INITIATE_IVR_SERVICE_FAILURE : String = "Initiate IVR service failure"
    public var EMPTY_AUTHENTICATE_EMAIL_SERVICE : String = "Authenticate Email is empty"
    public var AUTHENTICATE_EMAIL_SERVICE_FAILURE : String = "Authenticate Email service failure"
    public var EMPTY_AUTHENTICATE_SMS_SERVICE : String = "Authenticate SMS is empty"
    public var AUTHENTICATE_SMS_SERVICE_FAILURE : String = "Authenticate SMS service failure"
    public var EMPTY_AUTHENTICATE_IVR_SERVICE : String = "Authenticate IVR is empty"
    public var AUTHENTICATE_IVR_SERVICE_FAILURE : String = "Authenticate IVR service failure"
    public var EMPTY_AUTHENTICATE_BACKUPCODE_SERVICE : String = "Authenticate BACKUPCODE is empty"
    public var AUTHENTICATE_BACKUPCODE_SERVICE_FAILURE : String = "Authenticate BACKUPCODE service failure"
    public var EMPTY_INITIATE_BACKUPCODE_SERVICE : String = "Authenticate BACKUPCODE is empty"
    public var INITIATE_BACKUPCODE_SERVICE_FAILURE : String = "Authenticate BACKUPCODE service failure"
    public var EMPTY_INITIATE_TOTP_SERVICE : String = "Authenticate TOTP is empty"
    public var INITIATE_TOTP_SERVICE_FAILURE : String = "Authenticate TOTP service failure"
    public var EMPTY_AUTHENTICATE_TOTP_SERVICE : String = "Authenticate TOTP is empty"
    public var AUTHENTICATE_TOTP_SERVICE_FAILURE : String = "Authenticate TOTP service failure"
    public var EMPTY_MFA_CONTINUE_SERVICE : String = "MFA continue is empty"
    public var MFA_CONTINUE_SERVICE_FAILURE : String = "MFA continue service failure"
    public var EMPTY_CONSENT_CONTINUE_SERVICE : String = "Consent continue is empty"
    public var CONSENT_CONTINUE_SERVICE_FAILURE : String = "Consent continue service failure"
    public var EMPTY_REGISTRATION_FIELDS_SERVICE : String = "Registration fields is empty"
    public var REGISTRATION_FIELDS_SERVICE_FAILURE : String = "Registration fields service failure"
    public var EMPTY_REGISTRATION_SERVICE : String = "Registration is empty"
    public var REGISTRATION_SERVICE_FAILURE : String = "Registration service failure"
    public var EMPTY_PATTERN_SETUP_SERVICE : String = "Pattern Setup is empty"
    public var PATTERN_SETUP_SERVICE_FAILURE : String = "Pattern Setup service failure"
    public var NOTIFICATION_TIMEOUT: String = "Device Verification Failure. Notification Time out"
    public var EMPTY_VALIDATE_DEVICE_SERVICE : String = "Device validation is empty"
    public var VALIDATE_DEVICE_SERVICE_FAILURE : String = "Device validation service failure"
    public var EMPTY_PATTERN_SCANNED_SERVICE : String = "Pattern Scanned is empty"
    public var PATTERN_SCANNED_SERVICE_FAILURE : String = "Pattern Scanned service failure"
    public var EMPTY_PATTERN_ENROLLED_SERVICE : String = "Pattern Enrolled is empty"
    public var PATTERN_ENROLLED_SERVICE_FAILURE : String = "Pattern Enrolled service failure"
    public var EMPTY_PATTERN_INITIATE_SERVICE : String = "Pattern Initiate is empty"
    public var PATTERN_INITIATE_SERVICE_FAILURE : String = "Pattern Initiate service failure"
    public var EMPTY_PATTERN_AUTHENTICATE_SERVICE : String = "Pattern Authenticate is empty"
    public var PATTERN_AUTHENTICATE_SERVICE_FAILURE : String = "Pattern Authenticate service failure"
    public var EMPTY_SETUP_EMAIL_SERVICE : String = "Setup Email is empty"
    public var SETUP_EMAIL_SERVICE_FAILURE : String = "Setup Email service failure"
    public var EMPTY_ENROLL_EMAIL_SERVICE : String = "Enroll Email is empty"
    public var ENROLL_EMAIL_SERVICE_FAILURE : String = "Enroll Email service failure"
    
    public var EMPTY_SETUP_SMS_SERVICE : String = "Setup SMS is empty"
    public var SETUP_SMS_SERVICE_FAILURE : String = "Setup SMS service failure"
    public var EMPTY_ENROLL_SMS_SERVICE : String = "Enroll SMS is empty"
    public var ENROLL_SMS_SERVICE_FAILURE : String = "Enroll SMS service failure"
    
    public var EMPTY_SETUP_IVR_SERVICE : String = "Setup IVR is empty"
    public var SETUP_IVR_SERVICE_FAILURE : String = "Setup IVR service failure"
    public var EMPTY_ENROLL_IVR_SERVICE : String = "Enroll IVR is empty"
    public var ENROLL_IVR_SERVICE_FAILURE : String = "Enroll IVR service failure"
    
    public var EMPTY_SETUP_BACKUPCODE_SERVICE : String = "Setup Backupcode is empty"
    public var SETUP_BACKUPCODE_SERVICE_FAILURE : String = "Setup Backupcode service failure"
    
    public var EMPTY_TOUCHID_SETUP_SERVICE : String = "Touch Id Setup is empty"
    public var TOUCHID_SETUP_SERVICE_FAILURE : String = "Touch Id Setup service failure"
    public var EMPTY_TOUCHID_SCANNED_SERVICE : String = "Touch Id Scanned is empty"
    public var TOUCHID_SCANNED_SERVICE_FAILURE : String = "Touch Id Scanned service failure"
    public var EMPTY_TOUCHID_ENROLLED_SERVICE : String = "Touch Id Enrolled is empty"
    public var TOUCHID_ENROLLED_SERVICE_FAILURE : String = "Touch Id Enrolled service failure"
    public var EMPTY_TOUCHID_INITIATE_SERVICE : String = "Touch Id Initiate is empty"
    public var TOUCHID_INITIATE_SERVICE_FAILURE : String = "Touch Id Initiate service failure"
    public var EMPTY_TOUCHID_AUTHENTICATE_SERVICE : String = "Touch Id Authenticate is empty"
    public var TOUCHID_AUTHENTICATE_SERVICE_FAILURE : String = "Touch Id Authenticate service failure"
    
    public var EMPTY_FACE_SETUP_SERVICE : String = "Face Setup is empty"
    public var FACE_SETUP_SERVICE_FAILURE : String = "Face Setup service failure"
    public var EMPTY_FACE_SCANNED_SERVICE : String = "Face Scanned is empty"
    public var FACE_SCANNED_SERVICE_FAILURE : String = "Face Scanned service failure"
    public var EMPTY_FACE_ENROLLED_SERVICE : String = "Face Enrolled is empty"
    public var FACE_ENROLLED_SERVICE_FAILURE : String = "Face Enrolled service failure"
    public var EMPTY_FACE_INITIATE_SERVICE : String = "Face Initiate is empty"
    public var FACE_INITIATE_SERVICE_FAILURE : String = "Face Initiate service failure"
    public var EMPTY_FACE_AUTHENTICATE_SERVICE : String = "Face Authenticate is empty"
    public var FACE_AUTHENTICATE_SERVICE_FAILURE : String = "Face Authenticate service failure"
    
    public var EMPTY_VOICE_SETUP_SERVICE : String = "Voice Setup is empty"
    public var VOICE_SETUP_SERVICE_FAILURE : String = "Voice Setup service failure"
    public var EMPTY_VOICE_SCANNED_SERVICE : String = "Voice Scanned is empty"
    public var VOICE_SCANNED_SERVICE_FAILURE : String = "Voice Scanned service failure"
    public var EMPTY_VOICE_ENROLLED_SERVICE : String = "Voice Enrolled is empty"
    public var VOICE_ENROLLED_SERVICE_FAILURE : String = "Voice Enrolled service failure"
    public var EMPTY_VOICE_INITIATE_SERVICE : String = "Voice Initiate is empty"
    public var VOICE_INITIATE_SERVICE_FAILURE : String = "Voice Initiate service failure"
    public var EMPTY_VOICE_AUTHENTICATE_SERVICE : String = "Voice Authenticate is empty"
    public var VOICE_AUTHENTICATE_SERVICE_FAILURE : String = "Voice Authenticate service failure"
    
    public var EMPTY_PUSH_SETUP_SERVICE : String = "Push Setup is empty"
    public var PUSH_SETUP_SERVICE_FAILURE : String = "Push Setup service failure"
    public var EMPTY_PUSH_SCANNED_SERVICE : String = "Push Scanned is empty"
    public var PUSH_SCANNED_SERVICE_FAILURE : String = "Push Scanned service failure"
    public var EMPTY_PUSH_ENROLLED_SERVICE : String = "Push Enrolled is empty"
    public var PUSH_ENROLLED_SERVICE_FAILURE : String = "Push Enrolled service failure"
    public var EMPTY_PUSH_INITIATE_SERVICE : String = "Push Initiate is empty"
    public var PUSH_INITIATE_SERVICE_FAILURE : String = "Push Initiate service failure"
    public var EMPTY_PUSH_AUTHENTICATE_SERVICE : String = "Push Authenticate is empty"
    public var PUSH_AUTHENTICATE_SERVICE_FAILURE : String = "Push Authenticate service failure"
    
    public var EMPTY_TOTP_SETUP_SERVICE : String = "TOTP Setup is empty"
    public var TOTP_SETUP_SERVICE_FAILURE : String = "TOTP Setup service failure"
    public var EMPTY_TOTP_SCANNED_SERVICE : String = "TOTP Scanned is empty"
    public var TOTP_SCANNED_SERVICE_FAILURE : String = "TOTP Scanned service failure"
    public var EMPTY_TOTP_ENROLLED_SERVICE : String = "TOTP Enrolled is empty"
    public var TOTP_ENROLLED_SERVICE_FAILURE : String = "TOTP Enrolled service failure"
    public var EMPTY_TOTP_INITIATE_SERVICE : String = "TOTP Initiate is empty"
    public var TOTP_INITIATE_SERVICE_FAILURE : String = "TOTP Initiate service failure"
    public var EMPTY_TOTP_AUTHENTICATE_SERVICE : String = "TOTP Authenticate is empty"
    public var TOTP_AUTHENTICATE_SERVICE_FAILURE : String = "TOTP Authenticate service failure"
    
    public var EMPTY_INITIATE_ACCOUNT_VERIFICATION_SERVICE : String = "Initiate account verification is empty"
    public var INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE : String = "Initiate account verification service failure"
    
    public var EMPTY_VERIFY_ACCOUNT_SERVICE : String = "Verify account is empty"
    public var VERIFY_ACCOUNT_SERVICE_FAILURE : String = "Verify account service failure"

    public var EMPTY_INITIATE_RESET_PASSWORD_SERVICE : String = "Initiate reset password is empty"
    public var INITIATE_RESET_PASSWORD_SERVICE_FAILURE : String = "Initiate reset password service failure"
    
    public var EMPTY_HANDLE_RESET_PASSWORD_SERVICE : String = "Handle reset password is empty"
    public var HANDLE_RESET_PASSWORD_SERVICE_FAILURE : String = "Handle reset password service failure"
    
    public var PLACE_FINGER_ON_TOUCH_ID : String = "Please Authenticate, it's you!"
    
    public var EMPTY_DEDUPLICATION_DETAILS_SERVICE : String = "Get Deduplication details is empty"
    public var DEDUPLICATION_DETAILS_SERVICE_FAILURE : String = "Get Deduplication details service failure"
    
    public var EMPTY_REGISTER_DEDUPLICATION_SERVICE : String = "Register Deduplication is empty"
    public var REGISTER_DEDUPLICATION_SERVICE_FAILURE : String = "Register Deduplication service failure"
    
    public var EMPTY_DEDUPLICATION_LOGIN_SERVICE : String = "Login Deduplication is empty"
    public var DEDUPLICATION_LOGIN_SERVICE_FAILURE : String = "Login Deduplication service failure"
    
    public var EMPTY_CHANGE_PASSWORD_SERVICE : String = "Change password is empty"
    public var CHANGE_PASSWORD_SERVICE_FAILURE : String = "Change password service failure"
    
    public var EMPTY_USER_ACTIVITY_SERVICE : String = "User Activity is empty"
    public var USER_ACTIVITY_SERVICE_FAILURE : String = "User Activity service failure"
    
    public var EMPTY_UPDATE_USER_SERVICE : String = "Update User is empty"
    public var UPDATE_USER_SERVICE_FAILURE : String = "Update User service failure"
    
    public var EMPTY_IMAGE_UPLOAD_SERVICE : String = "Image upload is empty"
    public var IMAGE_UPLOAD_SERVICE_FAILURE : String = "Image upload service failure"
 
    public var EMPTY_LINK_ACCOUNT_SERVICE : String = "Link account is empty"
    public var LINK_ACCOUNT_SERVICE_FAILURE : String = "Link account service failure"
    
    public var EMPTY_UNLINK_ACCOUNT_SERVICE : String = "Unlink account is empty"
    public var UNLINK_ACCOUNT_SERVICE_FAILURE : String = "Unlink account service failure"
    
    public var EMPTY_GET_LINKED_USERS_SERVICE : String = "Get Linked users is empty"
    public var GET_LINKED_USERS_SERVICE_FAILURE : String = "Get Linked users service failure"
    
    public var EMPTY_VERIFY_ACCOUNT_LIST_SERVICE : String = "Verify account list is empty"
    public var VERIFY_ACCOUNT_LIST_SERVICE_FAILURE : String = "Verify account list service failure"
    
    public var LOCATION_LIST_SERVICE_FAILURE: String = "Location list service failure"
    public var LOCATION_EMISSION_SERVICE_FAILURE: String = "Location Emission service failure"
    
    public var BEACON_LIST_SERVICE_FAILURE: String = "Beacon list service failure"
}
