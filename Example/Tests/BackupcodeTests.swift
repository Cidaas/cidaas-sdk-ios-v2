//
//  BackupcodeTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas
import Mockingjay

class BackupcodeTests: QuickSpec {
    override func spec() {
        describe("Backupcode Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Backupcode test") {
                
                it("call configure Backupcode from public") {
                    
                    cidaas.configureBackupcode(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call configure Backupcode failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureBackupcode(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with Backupcode from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithBackupcode(code: "32842834", passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call login with Backupcode failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithBackupcode(code: "32842834", passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call configure backupcode controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var entity = SetupBackupcodeResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupBackupcodeResponseEntity.self, from: data)
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
                    
                    controller.configureBackupcode(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configure backupcode failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
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
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getSetupBackupcodeURL()
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.configureBackupcode(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configure backupcode with domain url nil failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var entity = SetupBackupcodeResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupBackupcodeResponseEntity.self, from: data)
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
                    
                    controller.configureBackupcode(sub: "kajshjasd", properties: properties!) {
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
                
                it("call configrue backupcode with sub nil failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var entity = SetupBackupcodeResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupBackupcodeResponseEntity.self, from: data)
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
                    
                    controller.configureBackupcode(sub: "", properties: properties!) {
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
                
                
                it("call login with backupcode with MFA controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with Passwordless controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with initiate failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), failure(error as Error as NSError))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with authenticate failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), failure(error as Error as NSError))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with mfa continue failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getMFAContinueURL(trackId: "kjahgdjhasdg")
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with passwordless continue failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), failure(error as Error as NSError))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with domain url nil failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with email nil failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: UsageTypes.PASSWORDLESS.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with usage type nil failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "", requestId: "jhfhgfyfhtf", usageType: UsageTypes.MFA.rawValue, properties: properties!) {
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
                
                it("call login with backupcode with domain url nil failure controller") {
                    
                    let controller = BackupcodeVerificationController.shared
                    
                    var initiate_entity = InitiateBackupcodeResponseEntity()
                    
                    var jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    var decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        initiate_entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(initiate_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var authenticate_entity = AuthenticateBackupcodeResponseEntity()
                    
                    jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        authenticate_entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
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
                    
                    let initiate_urlString = baseURL + URLHelper.shared.getInitiateBackupcodeURL()
                    
                    self.stub(http(.post, uri: initiate_urlString), json(initiate_bodyParams))
                    
                    let authenticate_urlString = baseURL + URLHelper.shared.getAuthenticateBackupcodeURL()
                    
                    self.stub(http(.post, uri: authenticate_urlString), json(authenticate_bodyParams))
                    
                    let code_urlString = baseURL + URLHelper.shared.getPasswordlessContinueURL()
                    
                    self.stub(http(.post, uri: code_urlString), json(code_bodyParams))
                    
                    let login_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: login_urlString), json(login_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.loginWithBackupcode(email: "abc@gmail.com", mobile: "", sub: "", code: "123456", trackId: "kjahgdjhasdg", requestId: "jhfhgfyfhtf", usageType: "jahsasd", properties: properties!) {
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
