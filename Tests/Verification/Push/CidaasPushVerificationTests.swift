//
//  CidaasPushVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasPushVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var pushController = PushVerificationController.shared
    var PushService = PushVerificationService.shared
    
    func testAuthenticatePushResponseEntity() {
        var authzCodeEntity = AuthenticatePushResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"1231345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticatePushResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testEnrollPushResponseEntity() {
        var authzCodeEntity = EnrollPushResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"1231345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(EnrollPushResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiatePushResponseEntity() {
        var authzCodeEntity = InitiatePushResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\", \"current_status\":\"VERIFIED\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiatePushResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedPushResponseEntity() {
        var authzCodeEntity = ScannedPushResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ScannedPushResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupPushResponseEntity() {
        var authzCodeEntity = SetupPushResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"qrCode\":\"2343453453\", \"queryString\":\"1231345\", \"statusId\":\"2342343\", \"verifierId\":\"true\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupPushResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedPushEntity() {
        let entity = ScannedPushEntity()
        entity.statusId = "123123"
        entity.usage_pass = "13423453543"
        entity.deviceInfo = DeviceInfoModel()
        XCTAssertEqual(entity.usage_pass, "13423453543")
    }
    
    func testConfigureSmartPush() {
        self.cidaas.configureSmartPush(sub: "123") {
            switch $0 {
            case .success(let configureSmartPushSuccess):
                print("\nSub : \(configureSmartPushSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithSmartPush() {
        self.cidaas.loginWithSmartPush(email: "abc@gmail.com", requestId: "1322343", usageType: .PASSWORDLESS) {
            switch $0 {
            case .success(let loginWithSmartPushSuccess):
                print("\nSub : \(loginWithSmartPushSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureSmartPushController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.pushController.configurePush(sub: "123", properties: properties) {
            switch $0 {
            case .success(let configureSmartPushSuccess):
                print("\nSub : \(configureSmartPushSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithSmartPushController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.pushController.loginWithPush(email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "1322343", usageType: .PASSWORDLESS, properties: properties) {
            switch $0 {
            case .success(let loginWithSmartPushSuccess):
                print("\nSub : \(loginWithSmartPushSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupPushService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let setupPushEntity = SetupPushEntity()
        setupPushEntity.client_id = "12312313"
        
        self.PushService.setupPush(accessToken: "asdasd23u23t7", setupPushEntity: setupPushEntity, properties: properties) {
            switch $0 {
            case .success(let configurePushSuccess):
                print("\nStatus Id : \(configurePushSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollPushService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollPushEntity = EnrollPushEntity()
        enrollPushEntity.verifierPassword = "RED[12313]"
        enrollPushEntity.statusId = "8672783462843"
        self.PushService.enrollPush(accessToken: "1231231", enrollPushEntity: enrollPushEntity, properties: properties) {
            switch $0 {
            case .success(let verifyPushSuccess):
                print("\nSub : \(verifyPushSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiatePushService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiatePushEntity = InitiatePushEntity()
        initiatePushEntity.email = "abc@gmail.com"
        initiatePushEntity.usageType = "PASSWORDLESS"
        
        self.PushService.initiatePush(initiatePushEntity: initiatePushEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithPushSuccess):
                print("\nStatus Id : \(loginWithPushSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticatePushService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticatePushEntity = AuthenticatePushEntity()
        authenticatePushEntity.verifierPassword = "RED[123]"
        authenticatePushEntity.statusId = "134iuywe8723y4"
        
        self.PushService.authenticatePush(authenticatePushEntity: authenticatePushEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithPushSuccess):
                print(loginWithPushSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
}
