//
//  CidaasSMSVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasSMSVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var smsController = SMSVerificationController.shared
    var smsService = SMSVerificationService.shared
    
    func testInitiateSMSResponseEntity() {
        var authzCodeEntity = InitiateSMSResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupSMSResponseEntity() {
        var authzCodeEntity = SetupSMSResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupSMSResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testVerifySMSResponseEntity() {
        var authzCodeEntity = VerifySMSResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"1231345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(VerifySMSResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testConfigureSMS() {
        self.cidaas.configureSMS(sub: "123123") {
            switch $0 {
            case .success(let configureSMSSuccess):
                print("\nStatus Id : \(configureSMSSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testVerifySMS() {
        self.cidaas.verifySMS(statusId: "843756876734534", code: "123123") {
            switch $0 {
            case .success(let verifySMSSuccess):
                print("\nSub : \(verifySMSSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithSMS() {
        let passwordlessEntity = PasswordlessEntity()
        self.cidaas.loginWithSMS(passwordlessEntity: passwordlessEntity) {
            switch $0 {
            case .success(let loginWithSMSSuccess):
                print("\nStatus Id : \(loginWithSMSSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
 
    func testConfigureSMSController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.smsController.configureSMS(sub: "123123", properties: properties) {
            switch $0 {
            case .success(let configureSMSSuccess):
                print("\nStatus Id : \(configureSMSSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testVerifySMSController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.smsController.verifySMS(statusId: "2543676754735275", code: "123123", properties: properties) {
            switch $0 {
            case .success(let verifySMSSuccess):
                print("\nSub : \(verifySMSSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithSMSController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.smsController.loginWithSMS(email: "abc@gmail.com", mobile: "+91932984728", sub: "123123", trackId: "12312313487", requestId: "82736482734", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties) {
            switch $0 {
            case .success(let loginWithSMSSuccess):
                print("\nStatus Id : \(loginWithSMSSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupSMSService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.smsService.setupSMS(access_token: "asdasd23u23t7", properties: properties) {
            switch $0 {
            case .success(let configureSMSSuccess):
                print("\nStatus Id : \(configureSMSSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollSMSService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollSMSEntity = EnrollSMSEntity()
        enrollSMSEntity.code = "123123"
        enrollSMSEntity.statusId = "8672783462843"
        self.smsService.enrollSMS(access_token: "1231231", enrollSMSEntity: enrollSMSEntity, properties: properties) {
            switch $0 {
            case .success(let verifySMSSuccess):
                print("\nSub : \(verifySMSSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateSMSService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateSMSEntity = InitiateSMSEntity()
        initiateSMSEntity.email = "abc@gmail.com"
        initiateSMSEntity.usageType = "PASSWORDLESS"
        
        self.smsService.initiateSMS(initiateSMSEntity: initiateSMSEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithSMSSuccess):
                print("\nStatus Id : \(loginWithSMSSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateSMSService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateSMSEntity = AuthenticateSMSEntity()
        authenticateSMSEntity.code = "13234"
        authenticateSMSEntity.statusId = "134iuywe8723y4"
        
        self.smsService.authenticateSMS(authenticateSMSEntity: authenticateSMSEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithSMSSuccess):
                print(loginWithSMSSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    
}
