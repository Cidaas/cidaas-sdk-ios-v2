//
//  CidaasPatternVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasPatternVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var patternController = PatternVerificationController.shared
    var patternService = PatternVerificationService.shared
    
    func testAuthenticatePatternResponseEntity() {
        var authzCodeEntity = AuthenticatePatternResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticatePatternResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testEnrollPatternResponseEntity() {
        var authzCodeEntity = EnrollPatternResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(EnrollPatternResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiatePatternResponseEntity() {
        var authzCodeEntity = InitiatePatternResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\", \"current_status\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiatePatternResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedPatternResponseEntity() {
        var authzCodeEntity = ScannedPatternResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ScannedPatternResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupPatternResponseEntity() {
        var authzCodeEntity = SetupPatternResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"qrCode\":\"2343453453\", \"queryString\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupPatternResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedPatternEntity() {
        let entity = ScannedPatternEntity()
        entity.statusId = "123123"
        entity.usage_pass = "13423453543"
        entity.deviceInfo = DeviceInfoModel()
        XCTAssertEqual(entity.usage_pass, "13423453543")
    }
    
    func testConfigurePattern() {
        self.cidaas.configurePatternRecognition(pattern: "RED[12345]", sub: "123") {
            switch $0 {
            case .success(let configurePatternSuccess):
                print("\nSub : \(configurePatternSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithPattern() {
        self.cidaas.loginWithPatternRecognition(pattern: "RED[12345]", email: "abc@gmail.com", requestId: "123123", usageType: UsageTypes.PASSWORDLESS) {
            switch $0 {
            case .success(let loginWithPatternSuccess):
                print("\nSub : \(loginWithPatternSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigurePatternController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.patternController.configurePatternRecognition(pattern: "RED[12345]", sub: "123", properties: properties) {
            switch $0 {
            case .success(let configurePatternSuccess):
                print("\nSub : \(configurePatternSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithPatternController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.patternController.loginWithPatternRecognition(pattern: "RED[12345]", email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "123123", usageType: UsageTypes.PASSWORDLESS, properties: properties) {
            switch $0 {
            case .success(let loginWithPatternSuccess):
                print("\nSub : \(loginWithPatternSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupPatternService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let setupPatternEntity = SetupPatternEntity()
        setupPatternEntity.client_id = "12312313"
        
        self.patternService.setupPattern(accessToken: "asdasd23u23t7", setupPatternEntity: setupPatternEntity, properties: properties) {
            switch $0 {
            case .success(let configurePatternSuccess):
                print("\nStatus Id : \(configurePatternSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollPatternService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollPatternEntity = EnrollPatternEntity()
        enrollPatternEntity.verifierPassword = "RED[12313]"
        enrollPatternEntity.statusId = "8672783462843"
        self.patternService.enrollPattern(accessToken: "1231231", enrollPatternEntity: enrollPatternEntity, properties: properties) {
            switch $0 {
            case .success(let verifyPatternSuccess):
                print("\nSub : \(verifyPatternSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiatePatternService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiatePatternEntity = InitiatePatternEntity()
        initiatePatternEntity.email = "abc@gmail.com"
        initiatePatternEntity.usageType = "PASSWORDLESS"
        
        self.patternService.initiatePattern(initiatePatternEntity: initiatePatternEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithPatternSuccess):
                print("\nStatus Id : \(loginWithPatternSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticatePatternService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticatePatternEntity = AuthenticatePatternEntity()
        authenticatePatternEntity.verifierPassword = "RED[123]"
        authenticatePatternEntity.statusId = "134iuywe8723y4"
        
        self.patternService.authenticatePattern(authenticatePatternEntity: authenticatePatternEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithPatternSuccess):
                print(loginWithPatternSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
}
