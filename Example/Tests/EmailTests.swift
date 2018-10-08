//
//  EmailTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class EmailTests: QuickSpec {
    override func spec() {
        describe("Email Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Email test") {
                
                it("call configureEmail from public") {
                    
                    cidaas.configureEmail(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call configureEmail failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureEmail(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call enrollEmail from public") {
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call enrollEmail failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with email from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call login with email failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call verify email from public") {
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifyEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call verify email failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifyEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                
                
                
                it("call configure Email controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var entity = SetupEmailResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupEmailResponseEntity.self, from: data)
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
                    
                    controller.configureEmail(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configure Email failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
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
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getSetupEmailURL()
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.configureEmail(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configure Email with domain url nil failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var entity = SetupEmailResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupEmailResponseEntity.self, from: data)
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
                    
                    controller.configureEmail(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configrue Email with sub nil failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var entity = SetupEmailResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupEmailResponseEntity.self, from: data)
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
                    
                    controller.configureEmail(sub: "", properties: properties!) {
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
                
                
                it("call login with Email with MFA controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with Email with Passwordless controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Email with initiate failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), failure(error as Error as NSError))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Email with authenticate failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateEmailURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Email with mfa continue failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with Email with passwordless continue failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Email with domain url nil failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Email with email nil failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with Email with usage type nil failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with Email with domain url nil failure controller") {
                    
                    let controller = EmailVerificationController.shared
                    
                    var initiate_entity = InitiateEmailResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateEmailURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithEmail(email: "abc@gmail.com", mobile: "", sub: "",  trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: "jahsasd", properties: properties!) {
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
