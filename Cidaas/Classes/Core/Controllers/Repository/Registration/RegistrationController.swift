//
//  RegistrationController.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class RegistrationController {
    
    // shared instance
    public static var shared : RegistrationController = RegistrationController()
    
    // local variables
    public var registrationFields : [RegistrationFieldsResponseDataEntity] = []
    
    // constructor
    public init() {
        
    }
    
    // get registration fields from properties
    public func getRegistrationFields(locale: String, requestId: String, properties: Dictionary<String, String>, callback: @escaping(Result<RegistrationFieldsResponseEntity>) -> Void) {
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
        if (requestId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // getting mobile locale
        var acceptlanguage = locale
        if (acceptlanguage == "") {
            acceptlanguage = Locale.current.languageCode ?? "de"
        }
        
        // call getRegistrationFields service
        RegistrationService.shared.getRegistrationFields(acceptlanguage: acceptlanguage, requestId: requestId, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Registration Fields service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let consentResponse):
                // log success
                let loggerMessage = "Registration Fields service success : " + "Total registration fields - " + String(describing: consentResponse.data.count)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                self.registrationFields = consentResponse.data
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: consentResponse))
                }
            }
        }
    }
    
    // register user from properties
    public func registerUser(requestId: String, registrationEntity: RegistrationEntity, properties: Dictionary<String, String>, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
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
        if (requestId == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "requestId must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        
        // check mandatory fields if called registrationSetup
        if (self.registrationFields.count > 0) {
            let error = WebAuthError.shared.propertyMissingException()
            // check email
            if let emailKey = self.registrationFields.first(where: {$0.fieldKey == "email"}) {
                if (emailKey.required == true && registrationEntity.email == "") {
                    error.errorMessage = "email must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check given_name
            if let given_nameKey = self.registrationFields.first(where: {$0.fieldKey == "given_name"}) {
                if (given_nameKey.required == true && registrationEntity.given_name == "") {
                    error.errorMessage = "given_name must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check family_name
            if let family_nameKey = self.registrationFields.first(where: {$0.fieldKey == "family_name"}) {
                if (family_nameKey.required == true && registrationEntity.family_name == "") {
                    error.errorMessage = "family_name must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check mobile_number
            if let mobile_numberKey = self.registrationFields.first(where: {$0.fieldKey == "mobile_number"}) {
                if (mobile_numberKey.required == true && registrationEntity.mobile_number == "") {
                    error.errorMessage = "mobile_number must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check password
            if let passwordKey = self.registrationFields.first(where: {$0.fieldKey == "password"}) {
                if (passwordKey.required == true && registrationEntity.password == "") {
                    error.errorMessage = "password must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check password_echo
            if let password_echoKey = self.registrationFields.first(where: {$0.fieldKey == "password_echo"}) {
                if (password_echoKey.required == true && registrationEntity.password_echo == "") {
                    error.errorMessage = "password_echo must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
                if (registrationEntity.password != registrationEntity.password_echo) {
                    error.errorMessage = "password and password_echo must be same"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check username
            if let usernameKey = self.registrationFields.first(where: {$0.fieldKey == "username"}) {
                if (usernameKey.required == true && registrationEntity.username == "") {
                    error.errorMessage = "username must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check birthdate
            if let birthdateKey = self.registrationFields.first(where: {$0.fieldKey == "birthdate"}) {
                if (birthdateKey.required == true && registrationEntity.birthdate == "") {
                    error.errorMessage = "birthdate must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check provider
            if (registrationEntity.provider == "") {
                error.errorMessage = "provider must not be empty"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
            
            // custom field validation
            for(key, value) in registrationEntity.customFields {
                if let customKey = self.registrationFields.first(where: {$0.fieldKey == key}) {
                    if (customKey.required == true && value.value == "" ) {
                        error.errorMessage = "\(value.key) must not be empty"
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    }
                }
            }
        }
        
        // call registerUser service
        RegistrationService.shared.registerUser(requestId: requestId, registrationEntity: registrationEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Registration service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let consentResponse):
                // log success
                let loggerMessage = "Registration service success : " + "Sub - " + String(describing: consentResponse.data.sub)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: consentResponse))
                }
            }
        }
    }
    
    // update user from properties
    public func updateUser(sub: String, registrationEntity: RegistrationEntity, properties: Dictionary<String, String>, callback: @escaping(Result<UpdateUserResponseEntity>) -> Void) {
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
        if (sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        
        // check mandatory fields if called registrationSetup
        if (self.registrationFields.count > 0) {
            let error = WebAuthError.shared.propertyMissingException()
            // check email
            if let emailKey = self.registrationFields.first(where: {$0.fieldKey == "email"}) {
                if (emailKey.required == true && registrationEntity.email == "") {
                    error.errorMessage = "email must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check given_name
            if let given_nameKey = self.registrationFields.first(where: {$0.fieldKey == "given_name"}) {
                if (given_nameKey.required == true && registrationEntity.given_name == "") {
                    error.errorMessage = "given_name must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check family_name
            if let family_nameKey = self.registrationFields.first(where: {$0.fieldKey == "family_name"}) {
                if (family_nameKey.required == true && registrationEntity.family_name == "") {
                    error.errorMessage = "family_name must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check mobile_number
            if let mobile_numberKey = self.registrationFields.first(where: {$0.fieldKey == "mobile_number"}) {
                if (mobile_numberKey.required == true && registrationEntity.mobile_number == "") {
                    error.errorMessage = "mobile_number must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check username
            if let usernameKey = self.registrationFields.first(where: {$0.fieldKey == "username"}) {
                if (usernameKey.required == true && registrationEntity.username == "") {
                    error.errorMessage = "username must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check birthdate
            if let birthdateKey = self.registrationFields.first(where: {$0.fieldKey == "birthdate"}) {
                if (birthdateKey.required == true && registrationEntity.birthdate == "") {
                    error.errorMessage = "birthdate must not be empty"
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
            }
            // check provider
            if (registrationEntity.provider == "") {
                error.errorMessage = "provider must not be empty"
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
            
            // custom field validation
            for(key, value) in registrationEntity.customFields {
                if let customKey = self.registrationFields.first(where: {$0.fieldKey == key}) {
                    if (customKey.required == true && value.value == "" ) {
                        error.errorMessage = "\(value.key) must not be empty"
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    }
                }
            }
        }
        
        // get access token from sub
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Access token failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tokenResponse):
                // log success
                let loggerMessage = "Access Token success : " + "Access Token  - " + String(describing: tokenResponse.data.access_token)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // call updateUser service
                RegistrationService.shared.updateUser(access_token: tokenResponse.data.access_token, sub: sub, registrationEntity: registrationEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Registration service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let consentResponse):
                        // log success
                        let loggerMessage = "Registration service success : " + "Updated - " + String(describing: consentResponse.data.updated)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: consentResponse))
                        }
                    }
                }
            }
        }
    }
}
