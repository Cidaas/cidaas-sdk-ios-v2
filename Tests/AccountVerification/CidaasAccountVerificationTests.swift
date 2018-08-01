//
//  CidaasAccountVerificationTests.swift
//  CidaasTests
//
//  Created by ganesh on 28/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasAccountVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var accountVerificationController = AccountVerificationController.shared
    var accountVerificationService = AccountVerificationService.shared
    
    func testResetPasswordEntity() {
        let resetPasswordEntity = ResetPasswordEntity()
        resetPasswordEntity.password = "123"
        resetPasswordEntity.confirmPassword = "123"
        resetPasswordEntity.exchangeId = "12345"
        resetPasswordEntity.resetRequestId = "123456789"
        
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(resetPasswordEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            print(bodyParams["password"]!)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
        XCTAssertEqual(bodyParams["password"]!, "123")
    }
    
    func testInitiateAccountVerificationResponseEntity() {
        var authzCodeEntity = InitiateAccountVerificationResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"accvid\":\"123\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateAccountVerificationResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testVerifyAccountResponseEntity() {
        var authzCodeEntity = VerifyAccountResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(VerifyAccountResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiateAccountVerificationController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        accountVerificationController.initiateAccountVerification(requestId: "123123", sub: "123123", verificationMedium: "email", properties: properties){
            switch $0 {
            case .success(let response):
                print(response.data)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testVerifyAccountController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        accountVerificationController.verifyAccount(code: "34234234", properties: properties){
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testInitiateAccountVerificationService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let accountVerificationEntity = InitiateAccountVerificationEntity()
        accountVerificationEntity.requestId = "123123"
        accountVerificationEntity.sub = "123234345345"
        accountVerificationEntity.verificationMedium = "email"
        
        accountVerificationService.initiateAccountVerification(accountVerificationEntity: accountVerificationEntity, properties: properties){
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testVerifyAccountService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let accountVerificationEntity = VerifyAccountEntity()
        accountVerificationEntity.accvid = "134234"
        accountVerificationEntity.code = "123234"
        
        accountVerificationService.verifyAccount(accountVerificationEntity: accountVerificationEntity, properties: properties){
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
}
