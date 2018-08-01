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
    public var consent_name: String = ""
    public var consent_version: Int16 = 0
    public var track_id: String = ""
    
    // constructor
    public init() {
        
    }
    
    // getConsentDetails from properties
    public func getConsentDetails(consent_name: String, consent_version: Int16, track_id: String, properties: Dictionary<String, String>, callback: @escaping(Result<ConsentDetailsResponseEntity>) -> Void) {
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
        if (consent_name == "" || consent_version == 0 || track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "consent_name or track_id must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // keep in temporary memory
        self.track_id = track_id
        self.consent_name = consent_name
        self.consent_version = consent_version
        
        // call getConsentURL service
        ConsentService.shared.getConsentURL(consent_name: consent_name, consent_version: consent_version, properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Get Consent URL service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let serviceResponse):
                // log success
                let loggerMessage = "Get Consent URL service success : " + "Consent URL  - " + String(describing: serviceResponse.data)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                
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
                        
                        // assign consent url to the response
                        consentDetailsResponse.data.url = serviceResponse.data
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: consentDetailsResponse))
                        }
                    }
                }
            }
        }
    }
    
    // login after consent from properties
    public func loginAfterConsent(sub: String, accepted: Bool, properties: Dictionary<String, String>, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
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
        if (self.consent_name == "" || sub == "" || accepted == false || self.track_id == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "consent_name or sub or accepted or track_id must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // constrcut accept consent entity
        let acceptConsentEntity = AcceptConsentEntity()
        acceptConsentEntity.name = consent_name
        acceptConsentEntity.version = consent_version
        acceptConsentEntity.sub = sub
        acceptConsentEntity.accepted = accepted
        
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
                consentContinueEntity.name = self.consent_name
                consentContinueEntity.sub = sub
                consentContinueEntity.version = self.consent_version
                consentContinueEntity.trackId = self.track_id
                
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
