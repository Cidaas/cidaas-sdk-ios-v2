//
//  WebAuthErrorCode.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public enum WebAuthErrorCode : Int32 {
    case DEFAULT = 10000
    case FILE_NOT_FOUND = 10001
    case NO_CONTENT_IN_FILE = 10002
    case PROPERT_MISSING = 10003
    case REQUEST_ID_SERVICE_FAILURE = 10004
    case EMPTY_REQUEST_ID_SERVICE = 10005
    case EMPTY_LOGIN_URL = 10006
    case EMPTY_REDIRECT_URL = 10007
    case EMPTY_DELEGATE = 10008
    case USER_CANCELLED_LOGIN = 10009
    case CODE_NOT_FOUND = 10010
    case ACCESSTOKEN_SERVICE_FAILURE = 10011
    case EMPTY_LOGIN_URL_SERVICE = 10012
    case ERROR_JSON_PARSING = 10013
    case USER_INFO_SERVICE_FAILURE = 10014
    case EMPTY_CALLBACK = 10015
    case NO_USER_FOUND = 10016
    case REFRESH_TOKEN_SERVICE_FAILURE = 10017
    case EMPTY_TENANT_INFO_SERVICE = 10018
    case EMPTY_CLIENT_INFO_SERVICE = 10019
    case TENANT_INFO_SERVICE_FAILURE = 10020
    case CLIENT_INFO_SERVICE_FAILURE = 10021
    case EMPTY_LOGIN_WITH_CREDENTIAL_SERVICE = 10022
    case LOGIN_WITH_CREDENTIAL_SERVICE_FAILURE = 10023
    case EMPTY_CONSENT_URL_SERVICE = 10024
    case CONSENT_URL_SERVICE_FAILURE = 10025
    case EMPTY_CONSENT_DETAILS_SERVICE = 10026
    case CONSENT_DETAILS_SERVICE_FAILURE = 10027
    case EMPTY_ACCEPT_CONSENT_SERVICE = 10028
    case ACCEPT_CONSENT_SERVICE_FAILURE = 10029
    case EMPTY_MFA_LIST_SERVICE = 10030
    case MFA_LIST_SERVICE_FAILURE = 10031
    case EMPTY_INITIATE_EMAIL_SERVICE = 10032
    case INITIATE_EMAIL_SERVICE_FAILURE = 10033
    case EMPTY_INITIATE_SMS_SERVICE = 10034
    case INITIATE_SMS_SERVICE_FAILURE = 10035
    case EMPTY_INITIATE_IVR_SERVICE = 10036
    case INITIATE_IVR_SERVICE_FAILURE = 10037
    case EMPTY_AUTHENTICATE_EMAIL_SERVICE = 10038
    case AUTHENTICATE_EMAIL_SERVICE_FAILURE = 10039
    case EMPTY_AUTHENTICATE_SMS_SERVICE = 10040
    case AUTHENTICATE_SMS_SERVICE_FAILURE = 10041
    case EMPTY_AUTHENTICATE_IVR_SERVICE = 10042
    case AUTHENTICATE_IVR_SERVICE_FAILURE = 10043
    case EMPTY_AUTHENTICATE_BACKUPCODE_SERVICE = 10044
    case AUTHENTICATE_BACKUPCODE_SERVICE_FAILURE = 10045
    case EMPTY_INITIATE_BACKUPCODE_SERVICE = 10046
    case INITIATE_BACKUPCODE_SERVICE_FAILURE = 10047
    case EMPTY_INITIATE_TOTP_SERVICE = 10048
    case INITIATE_TOTP_SERVICE_FAILURE = 10049
    case EMPTY_AUTHENTICATE_TOTP_SERVICE = 10050
    case AUTHENTICATE_TOTP_SERVICE_FAILURE = 10051
    case EMPTY_MFA_CONTINUE_SERVICE = 10052
    case MFA_CONTINUE_SERVICE_FAILURE = 10053
    case EMPTY_CONSENT_CONTINUE_SERVICE = 10054
    case CONSENT_CONTINUE_SERVICE_FAILURE = 10055
    case EMPTY_REGISTRATION_FIELDS_SERVICE = 10056
    case REGISTRATION_FIELDS_SERVICE_FAILURE = 10057
    case EMPTY_REGISTRATION_SERVICE = 10058
    case REGISTRATION_SERVICE_FAILURE = 10059
    case CONVERSION_EXCEPTION = 10060
    case EMPTY_PATTERN_SETUP_SERVICE = 10061
    case PATTERN_SETUP_SERVICE_FAILURE = 10062
    case NOTIFICATION_TIMEOUT = 10063
    case EMPTY_VALIDATE_DEVICE_SERVICE = 10064
    case VALIDATE_DEVICE_SERVICE_FAILURE = 10065
    case EMPTY_PATTERN_SCANNED_SERVICE = 10066
    case PATTERN_SCANNED_SERVICE_FAILURE = 10067
    case EMPTY_PATTERN_ENROLLED_SERVICE = 10068
    case PATTERN_ENROLLED_SERVICE_FAILURE = 10069
    case EMPTY_PATTERN_INITIATE_SERVICE = 10070
    case PATTERN_INITIATE_SERVICE_FAILURE = 10071
    case EMPTY_PATTERN_AUTHENTICATE_SERVICE = 10072
    case PATTERN_AUTHENTICATE_SERVICE_FAILURE = 10073
    case EMPTY_SETUP_EMAIL_SERVICE = 10074
    case SETUP_EMAIL_SERVICE_FAILURE = 10075
    case EMPTY_ENROLL_EMAIL_SERVICE = 10076
    case ENROLL_EMAIL_SERVICE_FAILURE = 10077
    case EMPTY_SETUP_SMS_SERVICE = 10078
    case SETUP_SMS_SERVICE_FAILURE = 10079
    case EMPTY_ENROLL_SMS_SERVICE = 10080
    case ENROLL_SMS_SERVICE_FAILURE = 10081
    case EMPTY_SETUP_IVR_SERVICE = 10082
    case SETUP_IVR_SERVICE_FAILURE = 10083
    case EMPTY_ENROLL_IVR_SERVICE = 10084
    case ENROLL_IVR_SERVICE_FAILURE = 10085
    case EMPTY_SETUP_BACKUPCODE_SERVICE = 10086
    case SETUP_BACKUPCODE_SERVICE_FAILURE = 10087
    
    case EMPTY_TOUCHID_SETUP_SERVICE = 10088
    case TOUCHID_SETUP_SERVICE_FAILURE = 10089
    case EMPTY_TOUCHID_SCANNED_SERVICE = 10090
    case TOUCHID_SCANNED_SERVICE_FAILURE = 10091
    case EMPTY_TOUCHID_ENROLLED_SERVICE = 10092
    case TOUCHID_ENROLLED_SERVICE_FAILURE = 10093
    case EMPTY_TOUCHID_INITIATE_SERVICE = 10094
    case TOUCHID_INITIATE_SERVICE_FAILURE = 10095
    case EMPTY_TOUCHID_AUTHENTICATE_SERVICE = 10096
    case TOUCHID_AUTHENTICATE_SERVICE_FAILURE = 10097
    
    case EMPTY_FACE_SETUP_SERVICE = 10098
    case FACE_SETUP_SERVICE_FAILURE = 10099
    case EMPTY_FACE_SCANNED_SERVICE = 10100
    case FACE_SCANNED_SERVICE_FAILURE = 10101
    case EMPTY_FACE_ENROLLED_SERVICE = 10102
    case FACE_ENROLLED_SERVICE_FAILURE = 10103
    case EMPTY_FACE_INITIATE_SERVICE = 10104
    case FACE_INITIATE_SERVICE_FAILURE = 10105
    case EMPTY_FACE_AUTHENTICATE_SERVICE = 10106
    case FACE_AUTHENTICATE_SERVICE_FAILURE = 10107
    
    case EMPTY_VOICE_SETUP_SERVICE = 10108
    case VOICE_SETUP_SERVICE_FAILURE = 10109
    case EMPTY_VOICE_SCANNED_SERVICE = 10110
    case VOICE_SCANNED_SERVICE_FAILURE = 10111
    case EMPTY_VOICE_ENROLLED_SERVICE = 10112
    case VOICE_ENROLLED_SERVICE_FAILURE = 10113
    case EMPTY_VOICE_INITIATE_SERVICE = 10114
    case VOICE_INITIATE_SERVICE_FAILURE = 10115
    case EMPTY_VOICE_AUTHENTICATE_SERVICE = 10116
    case VOICE_AUTHENTICATE_SERVICE_FAILURE = 10117
    
    case EMPTY_PUSH_SETUP_SERVICE = 10118
    case PUSH_SETUP_SERVICE_FAILURE = 10119
    case EMPTY_PUSH_SCANNED_SERVICE = 10120
    case PUSH_SCANNED_SERVICE_FAILURE = 10121
    case EMPTY_PUSH_ENROLLED_SERVICE = 10122
    case PUSH_ENROLLED_SERVICE_FAILURE = 10123
    case EMPTY_PUSH_INITIATE_SERVICE = 10124
    case PUSH_INITIATE_SERVICE_FAILURE = 10125
    case EMPTY_PUSH_AUTHENTICATE_SERVICE = 10126
    case PUSH_AUTHENTICATE_SERVICE_FAILURE = 10127
    
    case EMPTY_TOTP_SETUP_SERVICE = 10128
    case TOTP_SETUP_SERVICE_FAILURE = 10129
    case EMPTY_TOTP_SCANNED_SERVICE = 10130
    case TOTP_SCANNED_SERVICE_FAILURE = 10131
    case EMPTY_TOTP_ENROLLED_SERVICE = 10132
    case TOTP_ENROLLED_SERVICE_FAILURE = 10133
    case EMPTY_TOTP_INITIATE_SERVICE = 10134
    case TOTP_INITIATE_SERVICE_FAILURE = 10135
    case EMPTY_TOTP_AUTHENTICATE_SERVICE = 10136
    case TOTP_AUTHENTICATE_SERVICE_FAILURE = 10137
    
    case EMPTY_INITIATE_ACCOUNT_VERIFICATION_SERVICE = 10138
    case INITIATE_ACCOUNT_VERIFICATION_SERVICE_FAILURE = 10139
    
    case EMPTY_VERIFY_ACCOUNT_SERVICE = 10140
    case VERIFY_ACCOUNT_SERVICE_FAILURE = 10141
    
    case EMPTY_INITIATE_RESET_PASSWORD_SERVICE = 10142
    case INITIATE_RESET_PASSWORD_SERVICE_FAILURE = 10143
    
    case EMPTY_HANDLE_RESET_PASSWORD_SERVICE = 10144
    case HANDLE_RESET_PASSWORD_SERVICE_FAILURE = 10145
    
    case EMPTY_DEDUPLICATION_DETAILS_SERVICE = 10146
    case DEDUPLICATION_DETAILS_SERVICE_FAILURE = 10147
    
    case EMPTY_REGISTER_DEDUPLICATION_SERVICE = 10148
    case REGISTER_DEDUPLICATION_SERVICE_FAILURE = 10149
    
    case EMPTY_DEDUPLICATION_LOGIN_SERVICE = 10150
    case DEDUPLICATION_LOGIN_SERVICE_FAILURE = 10151
    
    case EMPTY_CHANGE_PASSWORD_SERVICE = 10152
    case CHANGE_PASSWORD_SERVICE_FAILURE = 10153
    
    case EMPTY_USER_ACTIVITY_SERVICE = 10154
    case USER_ACTIVITY_SERVICE_FAILURE = 10155
    
    case EMPTY_UPDATE_USER_SERVICE = 10156
    case UPDATE_USER_SERVICE_FAILURE = 10157
    
    case EMPTY_IMAGE_UPLOAD_SERVICE = 10158
    case IMAGE_UPLOAD_SERVICE_FAILURE = 10159
    
    case EMPTY_LINK_ACCOUNT_SERVICE = 10160
    case LINK_ACCOUNT_SERVICE_FAILURE = 10161
    
    case EMPTY_GET_LINKED_USERS_SERVICE = 10162
    case GET_LINKED_USERS_SERVICE_FAILURE = 10163
    
    case EMPTY_UNLINK_ACCOUNT_SERVICE = 10164
    case UNLINK_ACCOUNT_SERVICE_FAILURE = 10165
    
    case VERIFY_ACCOUNT_LIST_SERVICE_FAILURE = 10166
    
    case LOCATION_LIST_SERVICE_FAILURE = 10167
    case LOCATION_EMISSION_SERVICE_FAILURE = 10168
    
    case BEACON_LIST_SERVICE_FAILURE = 10169
    case DOCUMENT_ENROLLED_SERVICE_FAILURE = 10170
    
    case SOCIAL_TOKEN_SERVICE_FAILURE = 10171
}
