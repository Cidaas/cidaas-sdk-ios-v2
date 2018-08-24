//
//  OauthExceptionDelegate.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public protocol OauthExceptionDelegate {
    
    // login related exceptions
    func fileNotFoundException() -> WebAuthError
    func noContentInFileException() -> WebAuthError
    func propertyMissingException() -> WebAuthError
    func loginURLMissingException() -> WebAuthError
    func redirectURLMissingException() -> WebAuthError
    func userCancelledException() -> WebAuthError
    func codeNotFoundException() -> WebAuthError
    func serviceFailureException(errorCode : Int32, errorMessage : String, statusCode : Int, error: Any) -> WebAuthError
    func emptyCallbackException() -> WebAuthError
    func noUserFoundException() -> WebAuthError
}
