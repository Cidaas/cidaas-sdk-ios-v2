//
//  CidaasIVRVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasIVRVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var ivrController = IVRVerificationController.shared
    var IVRService = IVRVerificationService.shared
    
    func testInitiateIVRResponseEntity() {
        var authzCodeEntity = InitiateIVRResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateIVRResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupIVRResponseEntity() {
        var authzCodeEntity = SetupIVRResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupIVRResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testVerifyIVRResponseEntity() {
        var authzCodeEntity = VerifyIVRResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(VerifyIVRResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testConfigureIVR() {
        self.cidaas.configureIVR(sub: "123123") {
            switch $0 {
            case .success(let configureIVRSuccess):
                print("\nStatus Id : \(configureIVRSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testVerifyIVR() {
        self.cidaas.verifyIVR(code: "123123") {
            switch $0 {
            case .success(let verifyIVRSuccess):
                print("\nSub : \(verifyIVRSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithIVR() {
        self.cidaas.loginWithIVR(email: "abc@gmail.com", usageType: .PASSWORDLESS) {
            switch $0 {
            case .success(let loginWithIVRSuccess):
                print("\nStatus Id : \(loginWithIVRSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureIVRController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.ivrController.configureIVR(sub: "123123", properties: properties) {
            switch $0 {
            case .success(let configureIVRSuccess):
                print("\nStatus Id : \(configureIVRSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testVerifyIVRController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.ivrController.verifyIVR(code: "123123", properties: properties) {
            switch $0 {
            case .success(let verifyIVRSuccess):
                print("\nSub : \(verifyIVRSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithIVRController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.ivrController.loginWithIVR(email: "abc@gmail.com", mobile: "+91932984728", sub: "123123", trackId: "12312313487", requestId: "82736482734", usageType: .PASSWORDLESS, properties: properties) {
            switch $0 {
            case .success(let loginWithIVRSuccess):
                print("\nStatus Id : \(loginWithIVRSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupIVRService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.IVRService.setupIVR(access_token: "asdasd23u23t7", properties: properties) {
            switch $0 {
            case .success(let configureIVRSuccess):
                print("\nStatus Id : \(configureIVRSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollIVRService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollIVREntity = EnrollIVREntity()
        enrollIVREntity.code = "123123"
        enrollIVREntity.statusId = "8672783462843"
        self.IVRService.enrollIVR(access_token: "1231231", enrollIVREntity: enrollIVREntity, properties: properties) {
            switch $0 {
            case .success(let verifyIVRSuccess):
                print("\nSub : \(verifyIVRSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateIVRService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateIVREntity = InitiateIVREntity()
        initiateIVREntity.email = "abc@gmail.com"
        initiateIVREntity.usageType = "PASSWORDLESS"
        
        self.IVRService.initiateIVR(initiateIVREntity: initiateIVREntity, properties: properties) {
            switch $0 {
            case .success(let loginWithIVRSuccess):
                print("\nStatus Id : \(loginWithIVRSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateIVRService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateIVREntity = AuthenticateIVREntity()
        authenticateIVREntity.code = "13234"
        authenticateIVREntity.statusId = "134iuywe8723y4"
        
        self.IVRService.authenticateIVR(authenticateIVREntity: authenticateIVREntity, properties: properties) {
            switch $0 {
            case .success(let loginWithIVRSuccess):
                print(loginWithIVRSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
}
