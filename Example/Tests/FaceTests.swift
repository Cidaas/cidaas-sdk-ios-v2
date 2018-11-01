//
//  FaceTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class FaceTests: QuickSpec {
    override func spec() {
        describe("FaceRecognition Test cases") {
            
            let cidaas = Cidaas.shared
            
            DBHelper.shared.setUserDeviceId(userDeviceId: "kahsdksad", key: "https://test.cidaas.de")
            
            context("FaceRecognition test") {
                
                it("call configure FaceRecognition from public") {
                    
                    cidaas.configureFaceRecognition(photo: UIImage(named: "conflictuser")!, sub: "87267324", logoUrl: "asdkashdjasd") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call configure FaceRecognition failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureFaceRecognition(photo: UIImage(named: "conflictuser")!, sub: "87267324", logoUrl: "asdkashdjasd") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with FaceRecognition from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithFaceRecognition(photo: UIImage(named: "conflictuser")!, passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call login with FaceRecognition failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithFaceRecognition(photo: UIImage(named: "conflictuser")!, passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call verify Face from public") {
                    
                    cidaas.verifyFace(photo: UIImage(named: "conflictuser")!, statusId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call verify Face failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.verifyFace(photo: UIImage(named: "conflictuser")!, statusId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                
                
                
                
                it("call configure Face controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var entity = EnrollFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollFaceResponseEntity.self, from: data)
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
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", intermediate_id: "asdasd", properties: properties!) {
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
                
                it("call configure Face with setup failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
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
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getSetupFaceURL()
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", properties: properties!) {
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
                
                it("call configure Face with device failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
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
                    
                    var setup_entity = SetupFaceResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupFaceResponseEntity.self, from: data)
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
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupFaceURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", intermediate_id: "asdasd", properties: properties!) {
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
                
                it("call configure Face with scanned failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
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
                    
                    var setup_entity = SetupFaceResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupFaceResponseEntity.self, from: data)
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
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupFaceURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let scanned_urlString = baseURL + URLHelper.shared.getScannedFaceURL()
                    
                    self.stub(http(.post, uri: scanned_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", intermediate_id: "asdasd", properties: properties!) {
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
                
                it("call configure Face with enroll failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
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
                    
                    var setup_entity = SetupFaceResponseEntity()
                    
                    let setup_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let setup_decoder = JSONDecoder()
                    do {
                        let data = setup_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        setup_entity = try setup_decoder.decode(SetupFaceResponseEntity.self, from: data)
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
                    
                    var scanned_entity = ScannedFaceResponseEntity()
                    
                    let scanned_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let scanned_decoder = JSONDecoder()
                    do {
                        let data = scanned_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        scanned_entity = try scanned_decoder.decode(ScannedFaceResponseEntity.self, from: data)
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
                    
                    let setup_urlString = baseURL + URLHelper.shared.getSetupFaceURL()
                    
                    self.stub(http(.post, uri: setup_urlString), json(setup_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let scanned_urlString = baseURL + URLHelper.shared.getScannedFaceURL()
                    
                    self.stub(http(.post, uri: scanned_urlString), json(scanned_bodyParams))
                    
                    let enroll_urlString = baseURL + URLHelper.shared.getEnrollFaceURL()
                    
                    self.stub(http(.post, uri: enroll_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = "asdasd"
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", intermediate_id: "asdasd", properties: properties!) {
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
                
                it("call configure Face with domain url nil failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var entity = EnrollFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollFaceResponseEntity.self, from: data)
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
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", properties: properties!) {
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
                
                it("call configrue Face with sub nil failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var entity = EnrollFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollFaceResponseEntity.self, from: data)
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
                    
                    controller.configureFace(sub: "kajshjasd", photo: UIImage(named: "tick")!, logoUrl: "asdkashdjasd", properties: properties!) {
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
                
                
                
                
                
                it("call login with Face with MFA controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    DBHelper.shared.setUserDeviceId(userDeviceId: "kahsdksad", key: (properties!["DomainURL"]) ?? "")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.MFA.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with Passwordless controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with initiate failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), failure(error as Error as NSError))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with device failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), failure(error as Error as NSError))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with authenticate failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace(email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick") ?? UIImage(), usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with mfa continue failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.MFA.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with passwordless continue failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let device_urlString = baseURL + URLHelper.shared.getValidateDeviceURL()
                    
                    self.stub(http(.post, uri: device_urlString), json(device_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with domain url nil failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.PASSWORDLESS.rawValue, intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with email nil failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo: UIImage(named: "tick")!, usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Face with usage type nil failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "jhfhgfyfhtf", photo: UIImage(named: "tick")!, usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with Face with domain url nil failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: "jahsasd", intermediate_id: "asjdhgajsdasd", properties: properties!) {
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
                
                it("call login with Face with intermediate id failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    var initiate_entity = InitiateFaceResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateFaceResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateFaceURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateFaceURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    Cidaas.intermediate_verifiation_id = ""
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with Face with user device id failure controller") {
                    
                    let controller = FaceVerificationController.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    DBHelper.shared.setUserDeviceId(userDeviceId: "", key: (properties!["DomainURL"]) ?? "")
                    
                    controller.loginWithFace( email: "abc@gmail.com", mobile: "", sub: "", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", photo:UIImage(named: "tick")!, usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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

