//
//  CidaasVoiceVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasVoiceVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var voiceController = VoiceVerificationController.shared
    var voiceService = VoiceVerificationService.shared
    
    func testAuthenticateVoiceResponseEntity() {
        var authzCodeEntity = AuthenticateVoiceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticateVoiceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testEnrollVoiceResponseEntity() {
        var authzCodeEntity = EnrollVoiceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(EnrollVoiceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiateVoiceResponseEntity() {
        var authzCodeEntity = InitiateVoiceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\", \"current_status\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateVoiceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedVoiceResponseEntity() {
        var authzCodeEntity = ScannedVoiceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ScannedVoiceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupVoiceResponseEntity() {
        var authzCodeEntity = SetupVoiceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"qrCode\":\"2343453453\", \"queryString\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupVoiceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedVoiceEntity() {
        let entity = ScannedVoiceEntity()
        entity.statusId = "123123"
        entity.usage_pass = "13423453543"
        entity.deviceInfo = DeviceInfoModel()
        XCTAssertEqual(entity.usage_pass, "13423453543")
    }
    
    func testConfigureVoice() {
        let voice = Data()
        self.cidaas.configureVoiceRecognition(sub: "123", voice: voice) {
            switch $0 {
            case .success(let configureVoiceSuccess):
                print("\nSub : \(configureVoiceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithVoice() {
        let voice = Data()
        self.cidaas.loginWithVoiceRecognition(email: "abc@gmail.com", requestId: "iu383487563", voice: voice, usageType: .PASSWORDLESS) {
            switch $0 {
            case .success(let loginWithVoiceSuccess):
                print("\nSub : \(loginWithVoiceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureVoiceController() {
        let voice = Data()
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.voiceController.configureVoice(sub: "123", voice: voice, properties: properties) {
            switch $0 {
            case .success(let configureVoiceSuccess):
                print("\nSub : \(configureVoiceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithVoiceController() {
        let voice = Data()
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.voiceController.loginWithVoice(email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "iu383487563", voice: voice, usageType: .PASSWORDLESS, properties: properties) {
            switch $0 {
            case .success(let loginWithVoiceSuccess):
                print("\nSub : \(loginWithVoiceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupVoiceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let setupVoiceEntity = SetupVoiceEntity()
        setupVoiceEntity.client_id = "12312313"
        
        self.voiceService.setupVoice(accessToken: "asdasd23u23t7", setupVoiceEntity: setupVoiceEntity, properties: properties) {
            switch $0 {
            case .success(let configureVoiceSuccess):
                print("\nStatus Id : \(configureVoiceSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollVoiceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollVoiceEntity = EnrollVoiceEntity()
        enrollVoiceEntity.verifierPassword = "RED[12313]"
        enrollVoiceEntity.statusId = "8672783462843"
        
        self.voiceService.enrollVoice(accessToken: "1231231", voice: Data(), enrollVoiceEntity: enrollVoiceEntity, properties: properties) {
            switch $0 {
            case .success(let verifyVoiceSuccess):
                print("\nSub : \(verifyVoiceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateVoiceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateVoiceEntity = InitiateVoiceEntity()
        initiateVoiceEntity.email = "abc@gmail.com"
        initiateVoiceEntity.usageType = "PASSWORDLESS"
        
        self.voiceService.initiateVoice(initiateVoiceEntity: initiateVoiceEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithVoiceSuccess):
                print("\nStatus Id : \(loginWithVoiceSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateVoiceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateVoiceEntity = AuthenticateVoiceEntity()
        authenticateVoiceEntity.verifierPassword = "RED[123]"
        authenticateVoiceEntity.statusId = "134iuywe8723y4"
        
        self.voiceService.authenticateVoice(voice: Data(), authenticateVoiceEntity: authenticateVoiceEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithVoiceSuccess):
                print(loginWithVoiceSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
}
