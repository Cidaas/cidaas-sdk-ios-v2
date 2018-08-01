//
//  CidaasBackupcodeVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasBackupcodeVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var backupcodeController = BackupcodeVerificationController.shared
    var BackupcodeService = BackupcodeVerificationService.shared
    
    func testAuthenticateBackupcodeResponseEntity() {
        var authzCodeEntity = AuthenticateBackupcodeResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"12324\", \"trackingCode\":\"872348642387\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiateBackupcodeResponseEntity() {
        var authzCodeEntity = InitiateBackupcodeResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"12324\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupBackupcodeResponseEntity() {
        var authzCodeEntity = SetupBackupcodeResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"12324\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupBackupcodeResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    
    func testConfigureBackupcode() {
        self.cidaas.configureBackupcode(sub: "123") {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithBackupcode() {
        self.cidaas.loginWithBackupcode(code: "123", requestId: "1231231", usageType: .PASSWORDLESS) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureBackupcodeController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.backupcodeController.configureBackupcode(sub: "123", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithBackupcodeController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.backupcodeController.loginWithBackupcode(email: "1123132", mobile: "", sub: "asasdq", code: "123", trackId: "asasdasdas861837", requestId: "1231231", usageType: .PASSWORDLESS, properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupBackupcodeService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.BackupcodeService.setupBackupcode(access_token: "asdasd23u23t7", properties: properties) {
            switch $0 {
            case .success(let configureBackupcodeSuccess):
                print("\nStatus Id : \(configureBackupcodeSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateBackupcodeService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateBackupcodeEntity = InitiateBackupcodeEntity()
        initiateBackupcodeEntity.email = "abc@gmail.com"
        initiateBackupcodeEntity.usageType = "PASSWORDLESS"
        
        self.BackupcodeService.initiateBackupcode(initiateBackupcodeEntity: initiateBackupcodeEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithBackupcodeSuccess):
                print("\nStatus Id : \(loginWithBackupcodeSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateBackupcodeService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateBackupcodeEntity = AuthenticateBackupcodeEntity()
        authenticateBackupcodeEntity.code = "13234"
        authenticateBackupcodeEntity.statusId = "134iuywe8723y4"
        
        self.BackupcodeService.authenticateBackupcode(authenticateBackupcodeEntity: authenticateBackupcodeEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithBackupcodeSuccess):
                print(loginWithBackupcodeSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
}
