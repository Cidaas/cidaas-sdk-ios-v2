//
//  CidaasResetPasswordTests.swift
//  CidaasTests
//
//  Created by ganesh on 28/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasResetPasswordTests: XCTestCase {

    var cidaas = Cidaas.shared
    var resetPasswordController = ResetPasswordController.shared
    var resetPasswordService = ResetPasswordService.shared
    
    func testInitiateResetPasswordEntity() {
        let initiateResetPasswordEntity = InitiateResetPasswordEntity()
        initiateResetPasswordEntity.email = "abc@gmail.com"
        initiateResetPasswordEntity.processingType = "CODE"
        initiateResetPasswordEntity.requestId = "12345"
        initiateResetPasswordEntity.resetMedium = "email"
        
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(initiateResetPasswordEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            print(bodyParams["email"]!)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
        XCTAssertEqual(bodyParams["email"]!, "abc@gmail.com")
    }
    
    func testInitiateResetPasswordResponseEntity() {
        var initiateResetPasswordResponseEntity = InitiateResetPasswordResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"12345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            initiateResetPasswordResponseEntity = try decoder.decode(InitiateResetPasswordResponseEntity.self, from: data)
            print(initiateResetPasswordResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(initiateResetPasswordResponseEntity.success, true)
    }
    
    func testHandleResetPasswordEntity() {
        let handleResetPasswordEntity = HandleResetPasswordEntity()
        handleResetPasswordEntity.code = "123"
        handleResetPasswordEntity.resetRequestId = "123456"
        
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(handleResetPasswordEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            print(bodyParams["code"]!)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
        XCTAssertEqual(bodyParams["code"]!, "123")
    }
    
    func testHandleResetPasswordResponseEntity() {
        var handleResetPasswordResponseEntity = HandleResetPasswordResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"exchangeId\":\"12345\",\"resetRequestId\":\"123456\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            handleResetPasswordResponseEntity = try decoder.decode(HandleResetPasswordResponseEntity.self, from: data)
            print(handleResetPasswordResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(handleResetPasswordResponseEntity.success, true)
    }
    
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
    
    func testResetPasswordResponseEntity() {
        var resetPasswordResponseEntity = ResetPasswordResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reseted\":true}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            resetPasswordResponseEntity = try decoder.decode(ResetPasswordResponseEntity.self, from: data)
            print(resetPasswordResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(resetPasswordResponseEntity.success, true)
    }
    
    func testInitiateResetPasswordController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.resetPasswordController.initiateResetPassword(requestId: "123123", email: "abc@gmailc.om", mobile: "+918635673", resetMedium: "email", properties: properties) {
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
    
    func testHandleResetPasswordController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.resetPasswordController.handleResetPassword(rprq: "87682736723562345236", code: "323424", properties: properties) {
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
    
    func testResetPasswordController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.resetPasswordController.resetPassword(rprq: "2365283645263764", exchangeId: "8627536456", password: "123", confirmPassword: "123", properties: properties) {
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
    
    func testInitiateResetPasswordService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateResetPasswordEntity = InitiateResetPasswordEntity()
        initiateResetPasswordEntity.email = "abc@gmail.com"
        initiateResetPasswordEntity.mobile = ""
        initiateResetPasswordEntity.processingType = "CODE"
        initiateResetPasswordEntity.requestId = "123123"
        initiateResetPasswordEntity.resetMedium = "email"
        
        self.resetPasswordService.initiateResetPassword(initiateResetPasswordEntity: initiateResetPasswordEntity, properties: properties) {
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
    
    func testHandleResetPasswordService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let handleResetPasswordEntity = HandleResetPasswordEntity()
        handleResetPasswordEntity.code = "123234"
        handleResetPasswordEntity.resetRequestId = "qewqe4234"
        
        self.resetPasswordService.handleResetPassword(handleResetPasswordEntity: handleResetPasswordEntity, properties: properties) {
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
    
    func testResetPasswordService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let resetPasswordEntity = ResetPasswordEntity()
        resetPasswordEntity.password = "123"
        resetPasswordEntity.confirmPassword = "123"
        resetPasswordEntity.exchangeId = "123123"
        resetPasswordEntity.resetRequestId = "213123123"
        
        self.resetPasswordService.resetPassword(resetPasswordEntity: resetPasswordEntity, properties: properties) {
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
}
