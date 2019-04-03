//
//  ConsentController.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ConsentController {
    
    // shared instance
    public static var shared : ConsentController = ConsentController()
    
    // constructor
    public init() {
        
    }
    
    // getConsentDetails from properties
    public func getConsentDetails(consent_name: String, properties: Dictionary<String, String>, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
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
        if (consent_name == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "consent_name must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call getConsentDetails service
        ConsentService.shared.getConsentDetails(consent_name: consent_name, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get Consent Details service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let consentDetailsResponse):
                // log success
                let loggerMessage = "Get Consent Details service success : " + "Consent URL  - " + String(describing: consentDetailsResponse.data)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: consentDetailsResponse))
                }
            }
        }
    }
    
    // getConsentDetails V2 from properties
    public func getConsentDetailsV2(consentData: ConsentDetailsV2RequestEntity, properties: Dictionary<String, String>, callback: @escaping(Result<ConsentDetailsV2ResponseEntity>) -> Void) {
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
        if (consentData.client_id == "" || consentData.consent_id == "" || consentData.consent_version_id == "" || consentData.requestId == "" || consentData.sub == "" || consentData.track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "consent_name must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call getConsentDetails service
        ConsentService.shared.getConsentDetailsV2(consentData: consentData, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get Consent Details service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let consentDetailsResponse):
                // log success
                let loggerMessage = "Get Consent Details service success : " + "Consent URL  - " + String(describing: consentDetailsResponse.data)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: consentDetailsResponse))
                }
            }
        }
    }
    
    // login after consent from properties
    public func loginAfterConsent(consentEntity: ConsentEntity, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil {
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
        if (consentEntity.consent_name == "" || consentEntity.version == "" || consentEntity.sub == "" || consentEntity.accepted == false || consentEntity.track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "consent_name or version or sub or accepted or track_id must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // constrcut accept consent entity
        let acceptConsentEntity = AcceptConsentEntity()
        acceptConsentEntity.name = consentEntity.consent_name
        acceptConsentEntity.sub = consentEntity.sub
        acceptConsentEntity.accepted = consentEntity.accepted
        acceptConsentEntity.version = consentEntity.version
        
        // call getConsentDetails service
        ConsentService.shared.acceptConsent(acceptConsentEntity: acceptConsentEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Accept consent service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Accept consent service success : " + "Consent URL  - " + String(describing: serviceResponse.data)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // prepare consent continue entity
                let consentContinueEntity = ConsentContinueEntity()
                consentContinueEntity.client_id = properties["ClientId"] ?? ""
                consentContinueEntity.name = consentEntity.consent_name
                consentContinueEntity.sub = consentEntity.sub
                consentContinueEntity.trackId = consentEntity.track_id
                consentContinueEntity.version = consentEntity.version
                
                // call consentContinue service
                ConsentService.shared.consentContinue(consentContinueEntity: consentContinueEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "consentContinue service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let authzCodeResponse):
                        // log success
                        let loggerMessage = "consentContinue service success : " + "Authz Code  - " + String(describing: authzCodeResponse.data.code)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // call get access token service
                        AccessTokenService.shared.getAccessToken(code: authzCodeResponse.data.code, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let tokenResponse):
                                
                                // construct login response
                                let loginResponse = LoginResponseEntity()
                                loginResponse.success = true
                                loginResponse.status = 200
                                loginResponse.data = tokenResponse
                                
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: loginResponse))
                                }
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func loginAfterConsentV2(consentEntity: ConsentEntity, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil || properties["ClientId"] == "" || properties["ClientId"] == nil {
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
        if (consentEntity.consent_version_id == "" || consentEntity.version == "" || consentEntity.sub == "" || consentEntity.accepted == false || consentEntity.track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.errorMessage = "consent_version_id or version or sub or accepted or track_id must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // constrcut accept consent entity
        let acceptConsentEntity = AcceptConsentV2Entity()
        acceptConsentEntity.client_id = consentEntity.client_id
        acceptConsentEntity.consent_id = consentEntity.consent_id
        acceptConsentEntity.consent_version_id = consentEntity.consent_version_id
        acceptConsentEntity.sub = consentEntity.sub
        
        // call getConsentDetails service
        ConsentService.shared.acceptConsentV2(acceptConsentEntity: acceptConsentEntity, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Accept consent service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Accept consent service success : " + "Consent URL  - " + String(describing: serviceResponse.data)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // prepare consent continue entity
                let consentContinueEntity = ConsentContinueEntity()
                consentContinueEntity.client_id = properties["ClientId"] ?? ""
                consentContinueEntity.name = consentEntity.consent_name
                consentContinueEntity.sub = consentEntity.sub
                consentContinueEntity.trackId = consentEntity.track_id
                consentContinueEntity.version = consentEntity.consent_version_id
                
                // call consentContinue service
                ConsentService.shared.consentContinue(consentContinueEntity: consentContinueEntity, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "consentContinue service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let authzCodeResponse):
                        // log success
                        let loggerMessage = "consentContinue service success : " + "Authz Code  - " + String(describing: authzCodeResponse.data.code)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // call get access token service
                        AccessTokenService.shared.getAccessToken(code: authzCodeResponse.data.code, properties: properties) {
                            switch $0 {
                            case .failure(let error):
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.failure(error: error))
                                }
                                return
                            case .success(let tokenResponse):
                                
                                // construct login response
                                let loginResponse = LoginResponseEntity()
                                loginResponse.success = true
                                loginResponse.status = 200
                                loginResponse.data = tokenResponse
                                
                                // return callback
                                DispatchQueue.main.async {
                                    callback(Result.success(result: loginResponse))
                                }
                                return
                            }
                        }
                    }
                }
            }
        }
    }
}
