//
//  CidaasEmailVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasEmailVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var emailController = EmailVerificationController.shared
    var emailService = EmailVerificationService.shared
    
    func testInitiateEmailResponseEntity() {
        var authzCodeEntity = InitiateEmailResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupEmailResponseEntity() {
        var authzCodeEntity = SetupEmailResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupEmailResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testVerifyEmailResponseEntity() {
        var authzCodeEntity = VerifyEmailResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"1231345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(VerifyEmailResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testConfigureEmail() {
        self.cidaas.configureEmail(sub: "123123") {
            switch $0 {
            case .success(let configureEmailSuccess):
                print("\nStatus Id : \(configureEmailSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testVerifyEmail() {
        self.cidaas.verifyEmail(statusId: "8712735267", code: "123123") {
            switch $0 {
            case .success(let verifyEmailSuccess):
                print("\nSub : \(verifyEmailSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithEmail() {
        let passwordlessEntity = PasswordlessEntity()
        self.cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
            switch $0 {
            case .success(let loginWithEmailSuccess):
                print("\nStatus Id : \(loginWithEmailSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureEmailController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.emailController.configureEmail(sub: "123123", properties: properties) {
            switch $0 {
            case .success(let configureEmailSuccess):
                print("\nStatus Id : \(configureEmailSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithEmailController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.emailController.loginWithEmail(email: "abc@gmail.com", mobile: "+919736357236", sub: "123123", trackId: "123123123414", requestId: "876287823647234", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties) {
            switch $0 {
            case .success(let loginWithEmailSuccess):
                print("\nStatus Id : \(loginWithEmailSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testVerifyEmailController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.emailController.verifyEmail(statusId: "8716254524543523", code: "123123", properties: properties) {
            switch $0 {
            case .success(let verifyEmailSuccess):
                print("\nSub : \(verifyEmailSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupEmailService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.emailService.setupEmail(access_token: "123123123", properties: properties) {
            switch $0 {
            case .success(let configureEmailSuccess):
                print("\nStatus Id : \(configureEmailSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollEmailService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let enrollEmailEntity = EnrollEmailEntity()
        enrollEmailEntity.code = "13123"
        enrollEmailEntity.statusId = "13123123"
        
        self.emailService.enrollEmail(access_token: "1231231", enrollEmailEntity: enrollEmailEntity, properties: properties) {
            switch $0 {
            case .success(let configureEmailSuccess):
                print(configureEmailSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateEmailService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateEmailEntity = InitiateEmailEntity()
        initiateEmailEntity.email = "abc@gmail.com"
        initiateEmailEntity.usageType = "PASSWORDLESS"
        
        self.emailService.initiateEmail(initiateEmailEntity: initiateEmailEntity, properties: properties) {
            switch $0 {
            case .success(let configureEmailSuccess):
                print(configureEmailSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateEmailService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateEmailEntity = AuthenticateEmailEntity()
        authenticateEmailEntity.code = "123123"
        authenticateEmailEntity.statusId = "123187861"
        
        self.emailService.authenticateEmail(authenticateEmailEntity: authenticateEmailEntity, properties: properties) {
            switch $0 {
            case .success(let configureEmailSuccess):
                print(configureEmailSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
}
