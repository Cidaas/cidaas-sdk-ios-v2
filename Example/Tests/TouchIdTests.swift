//
//  TouchIdTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class TouchIdTests: QuickSpec {
    override func spec() {
        describe("TouchIdRecognition Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("TouchIdRecognition test") {
                
                it("call configure TouchIdRecognition from public") {
                    
                    cidaas.configureTouchId(sub: "87267324", logoUrl: "askdjhas") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call configure TouchIdRecognition failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureTouchId(sub: "87267324", logoUrl: "askdjhas") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with TouchIdRecognition from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithTouchId(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call login with TouchIdRecognition failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithTouchId(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call verify TouchId from public") {
                    
                    cidaas.verifyTouchId(statusId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call verify TouchId failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.verifyTouchId(statusId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                
                
                it("call configure Touch controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var entity = EnrollTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", intermediate_id: "asdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure Touch with setup failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getSetupTouchIdURL()
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure Touch with intermediate id failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_entity = SetupTouchResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupTouchResponseEntity.self, from: data)
                        print(setup_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(setup_entity)
                        setup_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupTouchIdURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure Touch with device failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_entity = SetupTouchResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupTouchResponseEntity.self, from: data)
                        print(setup_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(setup_entity)
                        setup_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupTouchIdURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", intermediate_id: "asdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure Touch with scanned failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_entity = SetupTouchResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupTouchResponseEntity.self, from: data)
                        print(setup_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(setup_entity)
                        setup_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupTouchIdURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let scanned_urlString = baseURL + URLHelper.shared.getScannedTouchIdURL()
                    
                    self.stub(http(.post, uri: scanned_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", intermediate_id: "asdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure Touch with enroll failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_entity = SetupTouchResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupTouchResponseEntity.self, from: data)
                        print(setup_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var scanned_entity = ScannedTouchResponseEntity()
                    
                    let scanned_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let scanned_decoder = JSONDecoder()
                    do {
                        let data = scanned_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        scanned_entity = try scanned_decoder.decode(ScannedTouchResponseEntity.self, from: data)
                        print(scanned_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var setup_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(setup_entity)
                        setup_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var scanned_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(scanned_entity)
                        scanned_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupTouchIdURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let scanned_urlString = baseURL + URLHelper.shared.getScannedTouchIdURL()
                    
                    self.stub(http(.post, uri: scanned_urlString), json(scanned_bodyParams))
                    
                    let enroll_urlString = baseURL + URLHelper.shared.getEnrollTouchIdURL()
                    
                    self.stub(http(.post, uri: enroll_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", intermediate_id: "asdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configure Touch with domain url nil failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var entity = EnrollTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "kajshjasd", logoUrl: "askdjhas", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call configrue Touch with sub nil failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var entity = EnrollTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureTouchId(sub: "", logoUrl: "askdjhas", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                
                
                it("call login with Touch with MFA controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    DBHelper.shared.setUserDeviceId(userDeviceId: "kahsdksad", key: (properties!["DomainURL"]) ?? "")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.MFA.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with Passwordless controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with initiate failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), failure(error as Error as NSError))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with device failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), failure(error as Error as NSError))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with authenticate failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId(email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with mfa continue failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.MFA.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with passwordless continue failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_entity = ValidateDeviceResponseEntity()
                    
                    let device_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"adfasdfasd\"}}"
                    let device_decoder = JSONDecoder()
                    do {
                        let data = device_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        device_entity = try device_decoder.decode(ValidateDeviceResponseEntity.self, from: data)
                        print(device_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var device_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(device_entity)
                        device_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with domain url nil failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with email nil failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with usage type nil failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.MFA.rawValue, properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with domain url nil failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: "jahsasd", intermediate_id: "asjdhgajsdasd", properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with intermediate id failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    var initiate_entity = InitiateTouchResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateTouchResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(authenticate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_entity = LoginResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        login_entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(login_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var initiate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(initiate_entity)
                        initiate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(authenticate_entity)
                        authenticate_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var login_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(login_entity)
                        login_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateTouchIdURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateTouchIdURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = ""
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf",  usageType: UsageTypes.MFA.rawValue, properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                it("call login with Touch with user device id failure controller") {
                    
                    let controller = TouchIdVerificationController.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    DBHelper.shared.setUserDeviceId(userDeviceId: "", key: (properties!["DomainURL"]) ?? "")
                    
                    controller.loginWithTouchId( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            expect.fulfill()
                            break
                        case .success(let response):
                            print(response.success)
                            expect.fulfill()
                            break
                        }
                    }
                    
                    self.waitForExpectations(timeout: 120, handler: { (error) in
                        if error != nil{
                            print("Unexpected failure with getting the data ",error!)
                        }
                    })
                }
                
                
                
            }
        }
    }
}
