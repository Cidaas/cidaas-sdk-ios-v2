//
//  CidaasTOTPTests.swift
//  CidaasTests
//
//  Created by ganesh on 31/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasTOTPTests: XCTestCase {
    
    func testAuthenticateTOTPResponseEntity() {
        var authzCodeEntity = AuthenticateTOTPResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticateTOTPResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testEnrollTOTPResponseEntity() {
        var authzCodeEntity = EnrollTOTPResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(EnrollTOTPResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiateTOTPResponseEntity() {
        var authzCodeEntity = InitiateTOTPResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\", \"current_status\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateTOTPResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedTOTPResponseEntity() {
        var authzCodeEntity = ScannedTOTPResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ScannedTOTPResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupTOTPResponseEntity() {
        var authzCodeEntity = SetupTOTPResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"qrCode\":\"2343453453\", \"queryString\":\"234234\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupTOTPResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedTOTPEntity() {
        let entity = ScannedTOTPEntity()
        entity.statusId = "123123"
        entity.usage_pass = "13423453543"
        entity.deviceInfo = DeviceInfoModel()
        XCTAssertEqual(entity.usage_pass, "13423453543")
    }
    
    func testEnrollTOTPEntity() {
        let entity = EnrollTOTPEntity()
        entity.statusId = "123123"
        entity.userDeviceId = "13423453543"
        entity.verifierPassword = "123"
        XCTAssertEqual(entity.verifierPassword, "123")
    }
    
    func testInitiateTOTPEntity() {
        let entity = InitiateTOTPEntity()
        entity.client_id = "qw234234"
        entity.email = "abc@gmail.com"
        entity.usage_pass = "123"
        XCTAssertEqual(entity.usage_pass, "123")
    }
    
}
