//
//  CidaasConsentTests.swift
//  CidaasTests
//
//  Created by ganesh on 28/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasConsentTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var consentController = ConsentController.shared
    var consentService = ConsentService.shared
    
    func testAcceptConsentResponseEntity() {
        var authzCodeEntity = AcceptConsentResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"name\":\"123\", \"client_id\":\"123\", \"sub\":\"123\", \"version\":\"123\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AcceptConsentResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testConsentResponseEntity() {
        var authzCodeEntity = ConsentResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":\"asdasd\"}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ConsentResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testConsentDetailsResponseEntity() {
        var authzCodeEntity = ConsentDetailsResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"_id\":\"123\", \"description\":\"123\", \"title\":\"123\", \"userAgreeText\":\"123\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ConsentDetailsResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testConsentErrorResponseEntity() {
        var authzCodeEntity = ConsentErrorResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"error\":{\"error\":\"error occured\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ConsentErrorResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testGetConsentDetails() {
        
        self.cidaas.getConsentDetails(consent_name: "default", consent_version: 0, track_id: "1232323") {
            switch $0 {
            case .success(let consentDetailsSuccess):
                print("\nTitle : \(consentDetailsSuccess.data.title)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginAfterConsent() {
        
        self.cidaas.loginAfterConsent(sub: "123123", accepted: true) {
            switch $0 {
            case .success(let loginAfterConsentSuccess):
                print("\nSub : \(loginAfterConsentSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetConsentDetailsController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.consentController.getConsentDetails(consent_name: "default", consent_version: 0, track_id: "1232323", properties: properties) {
            switch $0 {
            case .success(let consentDetailsSuccess):
                print("\nTitle : \(consentDetailsSuccess.data.title)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginAfterConsentController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.consentController.loginAfterConsent(sub: "123123", accepted: true, properties: properties) {
            switch $0 {
            case .success(let loginAfterConsentSuccess):
                print("\nSub : \(loginAfterConsentSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetConsentDetailsService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.consentService.getConsentDetails(consent_name: "default", properties: properties) {
            switch $0 {
            case .success(let consentDetailsSuccess):
                print("\nTitle : \(consentDetailsSuccess.data.title)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetConsentURLService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.consentService.getConsentURL(consent_name: "default", consent_version: 1, properties: properties) {
            switch $0 {
            case .success(let loginAfterConsentSuccess):
                print(loginAfterConsentSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAcceptConsentController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let acceptConsentEntity = AcceptConsentEntity()
        acceptConsentEntity.accepted = true
        acceptConsentEntity.client_id = "123123123"
        acceptConsentEntity.name = "default"
        acceptConsentEntity.version = 1
        
        self.consentService.acceptConsent(acceptConsentEntity: acceptConsentEntity, properties: properties) {
            switch $0 {
            case .success(let loginAfterConsentSuccess):
                print("\nSub : \(loginAfterConsentSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAcceptConsentService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let consentContinueEntity = ConsentContinueEntity()
        consentContinueEntity.client_id = "1324234"
        consentContinueEntity.name = "default"
        consentContinueEntity.sub = "238742834"
        consentContinueEntity.trackId = "23423"
        consentContinueEntity.version = 1
        
        self.consentService.consentContinue(consentContinueEntity: consentContinueEntity, properties: properties) {
            switch $0 {
            case .success(let loginAfterConsentSuccess):
                print(loginAfterConsentSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
}
