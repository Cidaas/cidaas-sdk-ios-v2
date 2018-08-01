//
//  HttpStatusCode.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public enum HttpStatusCode : Int {
    case OK = 200
    case NO_CONTENT = 204
    case TEMPORARY_REDIRECT = 307
    case BAD_REQUEST = 400
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    case METHOD_NOT_ALLOWED = 405
    case CONFLICT = 409
    case PAYLOAD_TOO_LARGE = 413
    case UNSUPPORTED_MEDIA_TYPE = 415
    case EXPECTATION_FAILED = 417
    case CANCEL_REQUEST = 499
    case INTERNAL_SERVER_ERROR = 500
    case DEFAULT = 501
    case BAD_GATEWAY = 502
    case SERVICE_UNAVAILABLE = 503
}
