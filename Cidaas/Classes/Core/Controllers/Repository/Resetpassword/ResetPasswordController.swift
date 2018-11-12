//
//  ResetPasswordController.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ResetPasswordController {
    
    // shared instance
    public static var shared : ResetPasswordController = ResetPasswordController()
    
    // constructor
    public init() {
        
    }
    
    // initiate reset password from properties
    public func initiateResetPassword(requestId: String, email: String = "", mobile: String = "", resetMedium: String, properties: Dictionary<String, String>, callback: @escaping(Result<InitiateResetPasswordResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (requestId == "" || resetMedium == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "requestId or resetMedium must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        if (resetMedium == "email" && email == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "email must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        if ((resetMedium == "sms" || resetMedium == "ivr") && mobile == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "mobile must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let initiateResetPasswordEntity = InitiateResetPasswordEntity()
        initiateResetPasswordEntity.email = email
        initiateResetPasswordEntity.mobile = mobile
        initiateResetPasswordEntity.processingType = "CODE"
        initiateResetPasswordEntity.requestId = requestId
        initiateResetPasswordEntity.resetMedium = resetMedium
        
        // call initiateResetPassword service
        ResetPasswordService.shared.initiateResetPassword(initiateResetPasswordEntity: initiateResetPasswordEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Initiate reset password service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Initiate reset password service success : " + "Reset Request Id - " + serviceResponse.data.rprq
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
    
    // handle reset password from properties
    public func handleResetPassword(rprq: String, code: String, properties: Dictionary<String, String>, callback: @escaping(Result<HandleResetPasswordResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (code == "" || rprq == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "code or rprq must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let handleResetPasswordEntity = HandleResetPasswordEntity()
        handleResetPasswordEntity.code = code
        handleResetPasswordEntity.resetRequestId = rprq
        
        // call handleResetPassword service
        ResetPasswordService.shared.handleResetPassword(handleResetPasswordEntity: handleResetPasswordEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Handle reset password service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Handle reset password service success : " + "Exchange Id - " + serviceResponse.data.exchangeId
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
    
    // reset password from properties
    public func resetPassword(rprq: String, exchangeId: String, password: String, confirmPassword: String, properties: Dictionary<String, String>, callback: @escaping(Result<ResetPasswordResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (password == "" || confirmPassword == "" || exchangeId == "" || rprq == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "password or confirmPassword or exchangeId or rprq must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        if (password != confirmPassword) {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "password and confirmPassword must be same"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // construct object
        let resetPasswordEntity = ResetPasswordEntity()
        resetPasswordEntity.password = password
        resetPasswordEntity.confirmPassword = confirmPassword
        resetPasswordEntity.exchangeId = exchangeId
        resetPasswordEntity.resetRequestId = rprq
        
        // call initiateResetPassword service
        ResetPasswordService.shared.resetPassword(resetPasswordEntity: resetPasswordEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Reset password service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Reset password service success : " + "Reseted - " + String(describing: serviceResponse.data.reseted)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: serviceResponse))
                }
            }
        }
    }
}
