//
//  SMSTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class SMSTests: QuickSpec {
    override func spec() {
        describe("SMS Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("SMS test") {
                
                it("call configure SMS from public") {
                    
                    cidaas.configureSMS(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call configure SMS failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureSMS(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call enroll SMS from public") {
                    
                    SMSVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollSMS(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call enroll SMS failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    SMSVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollSMS(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with SMS from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithSMS(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call login with SMS failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithSMS(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call verify SMS from public") {
                    
                    SMSVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifySMS(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call verify SMS failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    SMSVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifySMS(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                
                it("call configure SMS controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var entity = SetupSMSResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupSMSResponseEntity.self, from: data)
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
                    
                    controller.configureSMS(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configure SMS failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
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
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getSetupSMSURL()
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.configureSMS(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configure SMS with domain url nil failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var entity = SetupSMSResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupSMSResponseEntity.self, from: data)
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
                    
                    controller.configureSMS(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configrue SMS with sub nil failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var entity = SetupSMSResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupSMSResponseEntity.self, from: data)
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
                    
                    controller.configureSMS(sub: "", properties: properties!) {
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
                
                
                it("call login with SMS with MFA controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with SMS with Passwordless controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with SMS with initiate failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), failure(error as Error as NSError))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with SMS with authenticate failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateSMSURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with SMS with mfa continue failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with SMS with passwordless continue failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with SMS with domain url nil failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with SMS with SMS nil failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with SMS with usage type nil failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with SMS with domain url nil failure controller") {
                    
                    let controller = SMSVerificationController.shared
                    
                    var initiate_entity = InitiateSMSResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(initiate_entity.success)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateSMSURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithSMS(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: "jahsasd", properties: properties!) {
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
