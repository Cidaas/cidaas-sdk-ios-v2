//
//  CidaasTouchIdVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasTouchIdVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var touchController = TouchIdVerificationController.shared
    var touchService = TouchIdVerificationService.shared
    
    
    func testAuthenticateTouchIdResponseEntity() {
        var authzCodeEntity = AuthenticateTouchResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testEnrollTouchIdResponseEntity() {
        var authzCodeEntity = EnrollTouchResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(EnrollTouchResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiateTouchIdResponseEntity() {
        var authzCodeEntity = InitiateTouchResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\", \"current_status\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedTouchIdResponseEntity() {
        var authzCodeEntity = ScannedTouchResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ScannedTouchResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupTouchIdResponseEntity() {
        var authzCodeEntity = SetupTouchResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"qrCode\":\"2343453453\", \"queryString\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupTouchResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedTouchEntity() {
        let entity = ScannedTouchEntity()
        entity.statusId = "123123"
        entity.usage_pass = "13423453543"
        entity.deviceInfo = DeviceInfoModel()
        XCTAssertEqual(entity.usage_pass, "13423453543")
    }
    
    func testConfigureTouchId() {
        self.cidaas.configureTouchId(sub: "123") {
            switch $0 {
            case .success(let configureTouchIdSuccess):
                print("\nSub : \(configureTouchIdSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithTouchId() {
        let passwordlessEntity = PasswordlessEntity()
        self.cidaas.loginWithTouchId(passwordlessEntity: passwordlessEntity) {
            switch $0 {
            case .success(let loginWithTouchIdSuccess):
                print("\nSub : \(loginWithTouchIdSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureTouchIdController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.touchController.configureTouchId(sub: "123", properties: properties) {
            switch $0 {
            case .success(let configureTouchIdSuccess):
                print("\nSub : \(configureTouchIdSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithTouchIdController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.touchController.loginWithTouchId(email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "123123234", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties) {
            switch $0 {
            case .success(let loginWithTouchIdSuccess):
                print("\nSub : \(loginWithTouchIdSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupTouchService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let setupTouchEntity = SetupTouchEntity()
        setupTouchEntity.client_id = "12312313"
        
        self.touchService.setupTouchId(accessToken: "asdasd23u23t7", setupTouchIdEntity: setupTouchEntity, properties: properties) {
            switch $0 {
            case .success(let configureTouchSuccess):
                print("\nStatus Id : \(configureTouchSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollTouchService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollTouchEntity = EnrollTouchEntity()
        enrollTouchEntity.verifierPassword = "RED[12313]"
        enrollTouchEntity.statusId = "8672783462843"
        self.touchService.enrollTouchId(accessToken: "1231231", enrollTouchIdEntity: enrollTouchEntity, properties: properties) {
            switch $0 {
            case .success(let verifyTouchSuccess):
                print("\nSub : \(verifyTouchSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateTouchService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateTouchEntity = InitiateTouchEntity()
        initiateTouchEntity.email = "abc@gmail.com"
        initiateTouchEntity.usageType = "PASSWORDLESS"
        
        self.touchService.initiateTouchId(initiateTouchIdEntity: initiateTouchEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithTouchSuccess):
                print("\nStatus Id : \(loginWithTouchSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateTouchService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateTouchEntity = AuthenticateTouchEntity()
        authenticateTouchEntity.verifierPassword = "RED[123]"
        authenticateTouchEntity.statusId = "134iuywe8723y4"
        
        self.touchService.authenticateTouchId(authenticateTouchIdEntity: authenticateTouchEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithTouchSuccess):
                print(loginWithTouchSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
}
