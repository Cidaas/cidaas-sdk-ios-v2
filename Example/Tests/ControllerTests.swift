//
//  ControllerTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 12/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class ControllerTests: QuickSpec {
    override func spec() {
        describe("Controller Test cases") {
            
            context("Controller test") {
                
                it("call get access token from code controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    var entity = AccessTokenEntity()
                    
                    let jsonString = "{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccessTokenEntity.self, from: data)
                        print(entity.sub)
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
                    
                    controller.getAccessToken(code: "8765273452") {
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
                
                it("call get access token from code property nil failure controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    DBHelper.shared.setPropertyFile(properties: nil)
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.getAccessToken(code: "8765273452") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                            Cidaas.shared.readPropertyFile()
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
                
                it("call get access token from code failure controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.getAccessToken(code: "8765273452") {
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
                
                it("call get access token from sub with refresh token controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    var entity = AccessTokenEntity()
                    
                    let jsonString = "{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccessTokenEntity.self, from: data)
                        print(entity.sub)
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
                    
                    controller.getAccessToken(sub: "akjsdjagsds") {
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
                
                it("call get access token from sub from local db controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    let milliseconds = Date().timeIntervalSince1970
                    let seconds = Int64(milliseconds)
                    
                    let accessTokenModel = AccessTokenModel()
                    accessTokenModel.access_token = "12345"
                    accessTokenModel.expires_in = 86400
                    accessTokenModel.seconds =  seconds + 86400
                    accessTokenModel.sub = "hjghfhhhg"
                    
                    DBHelper.shared.setAccessToken(accessTokenModel: accessTokenModel)
                    
                    var entity = AccessTokenEntity()
                    
                    let jsonString = "{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccessTokenEntity.self, from: data)
                        print(entity.sub)
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
                    
                    controller.getAccessToken(sub: "hjghfhhhg") {
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
                
                it("call get access token from sub failure controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.getAccessToken(sub: "8765273452") {
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
                
                it("call get access token from refresh token controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    var entity = AccessTokenEntity()
                    
                    let jsonString = "{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccessTokenEntity.self, from: data)
                        print(entity.sub)
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
                    
                    controller.getAccessToken(refreshToken: "akjsdjagsds") {
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
                
                it("call get access token from refresh token failure controller") {
                    
                    let controller = AccessTokenController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.getAccessToken(refreshToken: "8765273452") {
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
                
                it("call initiate account verification controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    var entity = InitiateAccountVerificationResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"accvid\":\"123\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateAccountVerificationResponseEntity.self, from: data)
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
                    
                    controller.initiateAccountVerification(requestId: "asjhdgajsd", sub: "jasgdjasd", verificationMedium: "email", properties: properties!) {
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
                
                it("call initiate account verification with domain url nil failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.initiateAccountVerification(requestId: "asjhdgajsd", sub: "jasgdjasd", verificationMedium: "email", properties: properties!) {
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
                
                it("call initiate account verification with requestId nil failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.initiateAccountVerification(requestId: "", sub: "jasgdjasd", verificationMedium: "email", properties: properties!) {
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
                
                it("call verify account controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    var entity = VerifyAccountResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(VerifyAccountResponseEntity.self, from: data)
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
                    
                    controller.verifyAccount(accvid: "asdajhsdgjasd", code: "7644654", properties: properties!) {
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
                
                it("call verify account with domain url nil failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.verifyAccount(accvid: "jhasdjasd", code: "7652634", properties: properties!) {
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
                
                it("call verify account with accvid nil failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.verifyAccount(accvid: "", code: "7652634", properties: properties!) {
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
                
                it("call get account verification list controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    var entity = AccountVerificationListResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"EMAIL\":false, \"MOBILE\":false, \"USER_NAME\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccountVerificationListResponseEntity.self, from: data)
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
                    
                    controller.getAccountVerificationList(sub: "asdjhagjsda", properties: properties!) {
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
                
                it("call get account verification list with domain url nil failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getAccountVerificationList(sub: "asdjhagjsda", properties: properties!) {
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
                
                it("call get account verification list with accvid nil failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getAccountVerificationList(sub: "", properties: properties!) {
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
                
                it("call get account verification list failure controller") {
                    
                    let controller = AccountVerificationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getAccountVerificationList(sub: "jhagsjas", properties: properties!) {
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
                
                it("call change password controller") {
                    
                    let controller = ChangepasswordController.shared
                    
                    var entity = ChangePasswordResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"changed\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ChangePasswordResponseEntity.self, from: data)
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
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "1234"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "asdjhagjsda", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call change password with access token failure controller") {
                    
                    let controller = ChangepasswordController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: urlString), failure(error as Error as NSError))
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "1234"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "asdjhagjsda", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call change password with user info failure controller") {
                    
                    let controller = ChangepasswordController.shared
                    
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
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let user_info_urlString = baseURL + URLHelper.shared.getUserInfoURL()
                    
                    self.stub(http(.post, uri: user_info_urlString), failure(error as Error as NSError))
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "1234"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "asdjhagjsda", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call change password with change password failure controller") {
                    
                    let controller = ChangepasswordController.shared
                    
                    var acc_entity = LoginResponseEntity()
                    
                    let acc_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let acc_decoder = JSONDecoder()
                    do {
                        let data = acc_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        acc_entity = try acc_decoder.decode(LoginResponseEntity.self, from: data)
                        print(acc_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var user_info_entity = UserInfoEntity()
                    
                    let user_info_jsonString = "{\"sub\":\"123234232\",\"given_name\":\"Test\", \"family_name\":\"Demo\",\"groups\":[{\"sub\":\"adasdasd\"}],\"identities\":[{\"provider\":\"SELF\"}]}"
                    let user_info_decoder = JSONDecoder()
                    do {
                        let data = user_info_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        user_info_entity = try user_info_decoder.decode(UserInfoEntity.self, from: data)
                        print(user_info_entity.sub)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var acc_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(acc_entity)
                        acc_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var user_info_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(user_info_entity)
                        user_info_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(acc_bodyParams))
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let user_info_urlString = baseURL + URLHelper.shared.getUserInfoURL()
                    
                    self.stub(http(.get, uri: user_info_urlString), json(user_info_bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let change_password_urlString = baseURL + URLHelper.shared.getChangePasswordURL()
                    
                    self.stub(http(.post, uri: change_password_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "1234"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "asdjhagjsda", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call change password with domain url nil failure controller") {
                    
                    let controller = ChangepasswordController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "1234"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "asdjhagjsda", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call change password with sub nil failure controller") {
                    
                    let controller = ChangepasswordController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "1234"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call change password with password mismatch failure controller") {
                    
                    let controller = ChangepasswordController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "123"
                    changePasswordEntity.new_password = "12345"
                    changePasswordEntity.confirm_password = "1234"
                    
                    controller.changePassword(sub: "asdjhagjsda", changePasswordEntity: changePasswordEntity, properties: properties!) {
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
                
                it("call get client info controller") {
                    
                    let controller = ClientController.shared
                    
                    var entity = ClientInfoResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"passwordless_enabled\":true,\"logo_uri\":\"https://www.cidaas.com/wp-content/uploads/2018/02/logo-black.png\",\"login_providers\":[\"facebook\",\"google\",\"linkedin\"],\"policy_uri\":\"\",\"tos_uri\":\"\",\"client_name\":\"Single Page WebApp (Don\'t Edit)\",\"captcha_site_key\":\"6LcNAk0UAAAAAFf90A1OZx8Fj4cJkts_Tnv9sz0k\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ClientInfoResponseEntity.self, from: data)
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
                    
                    controller.getClientInfo(requestId: "asjhdgajsd", properties: properties!) {
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
                
                it("call get client info failure controller") {
                    
                    let controller = ClientController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getClientInfo(requestId: "asjhdgajsd", properties: properties!) {
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
                
                it("call get client info with domain url nil failure controller") {
                    
                    let controller = ClientController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getClientInfo(requestId: "asjhdgajsd", properties: properties!) {
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
                
                it("call get client info with requestId nil failure controller") {
                    
                    let controller = ClientController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getClientInfo(requestId: "", properties: properties!) {
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
                
                it("call get consent details controller") {
                    
                    let controller = ConsentController.shared
                    
                    var entity = ConsentDetailsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sensitive\":true,\"policyUrl\":\"https://abc.com\",\"userAgreeText\":\"I agree\", \"description\":\"d\", \"name\":\"a\", \"language\":\"test\", \"consentReceiptID\":\"test\", \"collectionMethod\":\"test\", \"jurisdiction\":\"test\", \"enabled\":true, \"consent_type\":\"test\", \"status\":\"test\", \"spiCat\":[\"test\"], \"services\":[{\"service\":\"Demo\", \"purposes\":[{\"purpose\":\"Demo\", \"purposeCategory\":\"test\", \"consentType\":\"test\", \"piiCategory\":\"test\", \"primaryPurpose\":true, \"termination\":\"test\", \"thirdPartyDisclosure\":true, \"thirdPartyName\":\"test\"}]}], \"piiControllers\":[{\"piiController\":\"Demo\", \"onBehalf\":true, \"contact\":\"test\", \"email\":\"test\", \"phone\":\"test\", \"address\":{\"streetAddress\":\"Test\", \"addressCountry\":\"test\"}}], \"version\":\"test\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ConsentDetailsResponseEntity.self, from: data)
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
                    
                    controller.getConsentDetails(consent_name: "hgfahsgdas", properties: properties!) {
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
                
                it("call get consent details failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getConsentDetails(consent_name: "hgfahsgdas", properties: properties!) {
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
                
                it("call get consent details with domain url nil failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getConsentDetails(consent_name: "hgfahsgdas", properties: properties!) {
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
                
                it("call get consent details with consent name nil failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getConsentDetails(consent_name: "", properties: properties!) {
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
                
                it("call login after consent controller") {
                    
                    let controller = ConsentController.shared
                    
                    var acc_entity = AcceptConsentResponseEntity()
                    
                    let acc_jsonString = "{\"success\":true,\"status\":200,\"data\":true}"
                    let acc_decoder = JSONDecoder()
                    do {
                        let data = acc_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        acc_entity = try acc_decoder.decode(AcceptConsentResponseEntity.self, from: data)
                        print(acc_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    let code_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    let code_decoder = JSONDecoder()
                    do {
                        let data = code_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try code_decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    
                    var token_entity = AccessTokenEntity()
                    
                    let token_jsonString = "{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}"
                    let token_decoder = JSONDecoder()
                    do {
                        let data = token_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        token_entity = try token_decoder.decode(AccessTokenEntity.self, from: data)
                        print(token_entity.access_token)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var acc_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(acc_entity)
                        acc_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var token_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(token_entity)
                        token_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let acc_urlString = baseURL + URLHelper.shared.getAcceptConsentURL()
                    
                    self.stub(http(.post, uri: acc_urlString), json(acc_bodyParams))
                    
                    let user_info_urlString = baseURL + URLHelper.shared.getConsentContinueURL(trackId: "asdasdasd")
                    
                    self.stub(http(.post, uri: user_info_urlString), json(code_bodyParams))
                    
                    let token_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: token_urlString), json(token_bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "jagsdhasd"
                    consentEntity.accepted = true
                    consentEntity.sub = "asdjhasdjasd"
                    consentEntity.track_id = "asdasdasd"
                    consentEntity.version = "hgjad"
                    
                    controller.loginAfterConsent(consentEntity: consentEntity, properties: properties!) {
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
                
                it("call login after consent with accept consent failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let acc_urlString = baseURL + URLHelper.shared.getAcceptConsentURL()
                    
                    self.stub(http(.post, uri: acc_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "jagsdhasd"
                    consentEntity.accepted = true
                    consentEntity.sub = "asdjhasdjasd"
                    consentEntity.track_id = "asdasdasd"
                    consentEntity.version = "hgjad"
                    
                    controller.loginAfterConsent(consentEntity: consentEntity, properties: properties!) {
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
                
                it("call login after consent with consent continue failure failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    var acc_entity = AcceptConsentResponseEntity()
                    
                    let acc_jsonString = "{\"success\":true,\"status\":200,\"data\":true}"
                    let acc_decoder = JSONDecoder()
                    do {
                        let data = acc_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        acc_entity = try acc_decoder.decode(AcceptConsentResponseEntity.self, from: data)
                        print(acc_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var acc_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(acc_entity)
                        acc_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let acc_urlString = baseURL + URLHelper.shared.getAcceptConsentURL()
                    
                    self.stub(http(.post, uri: acc_urlString), json(acc_bodyParams))
                    
                    let user_info_urlString = baseURL + URLHelper.shared.getConsentContinueURL(trackId: "asdasdasd")
                    
                    self.stub(http(.post, uri: user_info_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "jagsdhasd"
                    consentEntity.accepted = true
                    consentEntity.sub = "asdjhasdjasd"
                    consentEntity.track_id = "asdasdasd"
                    consentEntity.version = "hgjad"
                    
                    controller.loginAfterConsent(consentEntity: consentEntity, properties: properties!) {
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
                
                it("call login after consent with access token failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    var acc_entity = AcceptConsentResponseEntity()
                    
                    let acc_jsonString = "{\"success\":true,\"status\":200,\"data\":true}"
                    let acc_decoder = JSONDecoder()
                    do {
                        let data = acc_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        acc_entity = try acc_decoder.decode(AcceptConsentResponseEntity.self, from: data)
                        print(acc_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    var code_entity = AuthzCodeEntity()
                    
                    let code_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    let code_decoder = JSONDecoder()
                    do {
                        let data = code_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try code_decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var acc_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(acc_entity)
                        acc_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let acc_urlString = baseURL + URLHelper.shared.getAcceptConsentURL()
                    
                    self.stub(http(.post, uri: acc_urlString), json(acc_bodyParams))
                    
                    let user_info_urlString = baseURL + URLHelper.shared.getConsentContinueURL(trackId: "asdasdasd")
                    
                    self.stub(http(.post, uri: user_info_urlString), json(code_bodyParams))
                    
                    let token_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: token_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "jagsdhasd"
                    consentEntity.accepted = true
                    consentEntity.sub = "asdjhasdjasd"
                    consentEntity.track_id = "asdasdasd"
                    consentEntity.version = "hgjad"
                    
                    controller.loginAfterConsent(consentEntity: consentEntity, properties: properties!) {
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
                
                it("call login after consent with domain url nil failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "jagsdhasd"
                    consentEntity.accepted = true
                    consentEntity.sub = "asdjhasdjasd"
                    consentEntity.track_id = "asdasdasd"
                    consentEntity.version = "hgjad"
                    
                    controller.loginAfterConsent(consentEntity: consentEntity, properties: properties!) {
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
                
                it("call login after consent with consent name nil failure controller") {
                    
                    let controller = ConsentController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.accepted = true
                    consentEntity.sub = "asdjhasdjasd"
                    consentEntity.track_id = "asdasdasd"
                    consentEntity.version = "hgjad"
                    
                    controller.loginAfterConsent(consentEntity: consentEntity, properties: properties!) {
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
                
                it("call get deduplication details controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    var entity = DeduplicationDetailsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"email\":\"abc@gmail.com\", \"deduplicationList\":[{\"email\":\"ab@g.com\"}]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(DeduplicationDetailsResponseEntity.self, from: data)
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
                    
                    controller.getDeduplicationDetails(track_id: "abjasdhasd", properties: properties!) {
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
                
                it("call get deduplication details failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getDeduplicationDetails(track_id: "abjasdhasd", properties: properties!) {
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
                
                it("call get deduplication details with domain url nil failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getDeduplicationDetails(track_id: "abjasdhasd", properties: properties!) {
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
                
                it("call get deduplication details with trackid nil failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getDeduplicationDetails(track_id: "", properties: properties!) {
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
                
                it("call register deduplication controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    var entity = RegistrationResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"12345\", \"userStatus\":\"verified\", \"email_verified\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationResponseEntity.self, from: data)
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
                    
                    controller.registerDeduplication(track_id: "abjasdhasd", properties: properties!) {
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
                
                it("call register deduplication failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.registerDeduplication(track_id: "abjasdhasd", properties: properties!) {
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
                
                it("call register deduplication with domain url nil failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.registerDeduplication(track_id: "abjasdhasd", properties: properties!) {
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
                
                it("call register deduplication with trackid nil failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.registerDeduplication(track_id: "", properties: properties!) {
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
                
                it("call deduplication login controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    var acc_entity = LoginResponseEntity()
                    
                    let acc_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let acc_decoder = JSONDecoder()
                    do {
                        let data = acc_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        acc_entity = try acc_decoder.decode(LoginResponseEntity.self, from: data)
                        print(acc_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(acc_entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.deduplicationLogin(requestId: "jhgasdjas", sub: "jhgaushdasd", password: "12345", properties: properties!) {
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
                
                it("call deduplication login with login failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.deduplicationLogin(requestId: "jhgasdjas", sub: "jhgaushdasd", password: "12345", properties: properties!) {
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
                
                it("call deduplication login with access token failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    var code_entity = AuthzCodeEntity()
                    
                    let code_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    let code_decoder = JSONDecoder()
                    do {
                        let data = code_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try code_decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let urlString = baseURL + URLHelper.shared.getLoginDeduplicationURL()
                    
                    self.stub(http(.post, uri: urlString), json(code_bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let token_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: token_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.deduplicationLogin(requestId: "jhgasdjas", sub: "jhgaushdasd", password: "12345", properties: properties!) {
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
                
                it("call deduplication login with domain url nil failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.deduplicationLogin(requestId: "jhgasdjas", sub: "jhgaushdasd", password: "12345", properties: properties!) {
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
                
                it("call deduplication login with requestId nil failure controller") {
                    
                    let controller = DeduplicationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.deduplicationLogin(requestId: "", sub: "jhgaushdasd", password: "12345", properties: properties!) {
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
                
                it("call link account controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    var entity = LinkAccountResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"updated\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LinkAccountResponseEntity.self, from: data)
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
                    
                    controller.linkAccount(master_sub: "hfasdasd", sub_to_link: "kjhasdkjasd", properties: properties!) {
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
                
                it("call link account with access token failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.linkAccount(master_sub: "hfasdasd", sub_to_link: "kjhasdkjasd", properties: properties!) {
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
                
                it("call link account with link failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
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
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let link_urlString = baseURL + URLHelper.shared.getLinkUserURL()
                    
                    self.stub(http(.post, uri: link_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.linkAccount(master_sub: "hfasdasd", sub_to_link: "kjhasdkjasd", properties: properties!) {
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
                
                it("call link account with domain url nil failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.linkAccount(master_sub: "hfasdasd", sub_to_link: "kjhasdkjasd", properties: properties!) {
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
                
                it("call link account with master_sub nil failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.linkAccount(master_sub: "", sub_to_link: "kjhasdkjasd", properties: properties!) {
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
                
                it("call get linked users controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    var entity = LinkedUserListResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"identities\":[{\"email\":\"ab@g.com\",\"provider\":\"SELF\",\"sub\":\"35464563t\",\"_id\":\"43tg345345345\"}]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LinkedUserListResponseEntity.self, from: data)
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
                    
                    controller.getLinkedUsers(sub: "hfasdasd", properties: properties!) {
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
                
                it("call get linked users with access token failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getLinkedUsers(sub: "hfasdasd", properties: properties!) {
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
                
                it("call get linked users with link failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
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
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let link_urlString = baseURL + URLHelper.shared.getLinkUserURL()
                    
                    self.stub(http(.post, uri: link_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.getLinkedUsers(sub: "hfasdasd", properties: properties!) {
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
                
                it("call  get linked users with domain url nil failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getLinkedUsers(sub: "hfasdasd", properties: properties!) {
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
                
                it("call  get linked users with sub nil failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getLinkedUsers(sub: "", properties: properties!) {
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
                
                it("call unlink account controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    var entity = LinkAccountResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"updated\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LinkAccountResponseEntity.self, from: data)
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
                    
                    controller.unlinkAccount(identityId: "ajhsdhasd", sub: "hfasdasd", properties: properties!) {
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
                
                it("call unlink account with access token failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.unlinkAccount(identityId: "ajhsdhasd", sub: "hfasdasd", properties: properties!) {
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
                
                it("call unlink account with unlink failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
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
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let link_urlString = baseURL + URLHelper.shared.getLinkUserURL()
                    
                    self.stub(http(.post, uri: link_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    controller.unlinkAccount(identityId: "ajhsdhasd", sub: "hfasdasd", properties: properties!) {
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
                
                it("call unlink account with domain url nil failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.unlinkAccount(identityId: "ajhsdhasd", sub: "hfasdasd", properties: properties!) {
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
                
                it("call unlink account with sub nil failure controller") {
                    
                    let controller = LinkUnlinkController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.unlinkAccount(identityId: "ajhsdhasd", sub: "", properties: properties!) {
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
                
                it("call login with credentials controller") {
                    
                    let controller = LoginController.shared
                    
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
                    
                    self.stub(everything, json(bodyParams))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123"
                    
                    controller.loginWithCredentials(requestId: "jhasgdhjasd", loginEntity: loginEntity, properties: properties!) {
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
                
                it("call login with credentials with code failure controller") {
                    
                    let controller = LoginController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123"
                    
                    controller.loginWithCredentials(requestId: "jhasgdhjasd", loginEntity: loginEntity, properties: properties!) {
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
                
                it("call login with credentials with access token failure controller") {
                    
                    let controller = LoginController.shared
                    
                    var code_entity = AuthzCodeEntity()
                    
                    let code_jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    let code_decoder = JSONDecoder()
                    do {
                        let data = code_jsonString.data(using: .utf8)!
                        // decode the json data to object
                        code_entity = try code_decoder.decode(AuthzCodeEntity.self, from: data)
                        print(code_entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    // construct body params
                    var code_bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(code_entity)
                        code_bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let urlString = baseURL + URLHelper.shared.getLoginWithCredentialsURL()
                    
                    self.stub(http(.post, uri: urlString), json(code_bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let token_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: token_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123"
                    
                    controller.loginWithCredentials(requestId: "jhasgdhjasd", loginEntity: loginEntity, properties: properties!) {
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
                
                it("call login with credentials with domain url nil failure controller") {
                    
                    let controller = LoginController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123"
                    
                    controller.loginWithCredentials(requestId: "jhasgdhjasd", loginEntity: loginEntity, properties: properties!) {
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
                
                it("call login with credentials with requestId nil failure controller") {
                    
                    let controller = LoginController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123"
                    
                    controller.loginWithCredentials(requestId: "", loginEntity: loginEntity, properties: properties!) {
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
                
                it("call get request id controller") {
                    
                    let controller = RequestIdController.shared
                    
                    var entity = RequestIdResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"requestId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RequestIdResponseEntity.self, from: data)
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
                    
                    controller.getRequestId(properties: properties!) {
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
                
                it("call get request id failure controller") {
                    
                    let controller = RequestIdController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getRequestId(properties: properties!) {
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
                
                it("call get request id with domain url nil failure controller") {
                    
                    let controller = RequestIdController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getRequestId(properties: properties!) {
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
                
                it("call get tenant info controller") {
                    
                    let controller = TenantController.shared
                    
                    var entity = TenantInfoResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"tenant_name\":\"Demo\",\"allowLoginWith\":[\"Email\"]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(TenantInfoResponseEntity.self, from: data)
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
                    
                    controller.getTenantInfo(properties: properties!) {
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
                
                it("call get tenant info failure controller") {
                    
                    let controller = TenantController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getTenantInfo(properties: properties!) {
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
                
                it("call get tenant info with domain url nil failure controller") {
                    
                    let controller = TenantController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getTenantInfo(properties: properties!) {
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
                
                it("call get user activity controller") {
                    
                    let controller = UserActivityController.shared
                    
                    var entity = UserActivityResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"osName\":\"Demo\", \"socialIdentity\":{\"firstname\":\"Test\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(UserActivityResponseEntity.self, from: data)
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
                    
                    let userActivity = UserActivityEntity()
                    userActivity.sub = "jhagsdasd"
                    
                    controller.getUserActivity(userActivity: userActivity, properties: properties!) {
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
                
                it("call get user activity with access token failure controller") {
                    
                    let controller = UserActivityController.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let token_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: token_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let userActivity = UserActivityEntity()
                    userActivity.sub = "jhagsdasd"
                    
                    controller.getUserActivity(userActivity: userActivity, properties: properties!) {
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
                
                it("call get user activity with user activities failure controller") {
                    
                    let controller = UserActivityController.shared
                    
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
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let acc_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: acc_urlString), json(bodyParams))
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let baseURL = (properties!["DomainURL"]) ?? ""
                    
                    let user_activity_urlString = baseURL + URLHelper.shared.getUserActivityURL()
                    
                    self.stub(http(.post, uri: user_activity_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let userActivity = UserActivityEntity()
                    userActivity.sub = "jhagsdasd"
                    
                    controller.getUserActivity(userActivity: userActivity, properties: properties!) {
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
                
                it("call get user activity with domain url nil failure controller") {
                    
                    let controller = UserActivityController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let userActivity = UserActivityEntity()
                    userActivity.sub = "jhagsdasd"
                    
                    controller.getUserActivity(userActivity: userActivity, properties: properties!) {
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
                
                it("call get user activity with sub nil failure controller") {
                    
                    let controller = UserActivityController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let userActivity = UserActivityEntity()
                    userActivity.sub = ""
                    
                    controller.getUserActivity(userActivity: userActivity, properties: properties!) {
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
                
                it("call get registration fields controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
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
                    
                    let userActivity = UserActivityEntity()
                    userActivity.sub = "jhagsdasd"
                    
                    controller.getRegistrationFields(locale: "", requestId: "jhasgdjhagsdjasd", properties: properties!) {
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
                
                it("call get registration fields failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getRegistrationFields(locale: "", requestId: "jhasgdjhagsdjasd", properties: properties!) {
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
                
                it("call get registration fields with domain url nil failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    controller.getRegistrationFields(locale: "", requestId: "jhasgdjhagsdjasd", properties: properties!) {
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
                
                it("call get registration fields with requestId nil failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    controller.getRegistrationFields(locale: "", requestId: "", properties: properties!) {
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
                
                it("call register user controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"12345\", \"userStatus\":\"verified\", \"email_verified\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationResponseEntity.self, from: data)
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
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registerUser(requestId: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registerUser(requestId: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with domain url nil failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registerUser(requestId: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with requestId nil failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registerUser(requestId: "", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with email validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = ""
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with given_name validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = ""
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with family_name validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = ""
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with mobile number validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}}, {\"dataType\":\"MOBILE\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"mobile_number\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Mobile\",\"verificationRequired\":\"Given mobile is not verified.\",\"required\":\"Mobile is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = ""
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with password validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "Demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = ""
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with password_echo validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = ""
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with password mismatch validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "12345"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with birthdate validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"birthdate\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Birthdate\",\"verificationRequired\":\"Given Birthdate is not verified.\",\"required\":\"Birthdate is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = ""
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with provider validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = ""
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call register user with custom field validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"birthdate\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Birthdate\",\"verificationRequired\":\"Given Birthdate is not verified.\",\"required\":\"Birthdate is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city2\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":false,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city2\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city2\",\"required\":\"city2\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    registrationEntity.customFields = Dictionary<String, RegistrationCustomFieldsEntity>()
                    let city1 = RegistrationCustomFieldsEntity()
                    city1.dataType = "TEXT"
                    city1.id = "city1"
                    city1.key = "city1"
                    city1.readOnly = false
                    city1.value = ""
                    
                    let city3 = RegistrationCustomFieldsEntity()
                    city3.dataType = "TEXT"
                    city3.id = "city3"
                    city3.key = "city3"
                    city3.readOnly = false
                    city3.value = "asds"
                    
                    registrationEntity.customFields["city1"] = city1
                    registrationEntity.customFields["city3"] = city3
                    registrationEntity.customFields["city2"] = city3
                    
                    controller.registrationFields = entity.data
                    
                    controller.registerUser(requestId: "kbasjdbs", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = UpdateUserResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"updated\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(UpdateUserResponseEntity.self, from: data)
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
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user access token failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let token_urlString = (properties!["TokenURL"]) ?? ""
                    
                    self.stub(http(.post, uri: token_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with update failure controller") {
                    
                    let controller = RegistrationController.shared
                    
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
                    
                    let update_user_urlString = baseURL + URLHelper.shared.getUpdateUserURL(sub: "jhagsdghasd")
                    
                    self.stub(http(.post, uri: update_user_urlString), failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with domain url nil failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    var properties = DBHelper.shared.getPropertyFile()
                    
                    properties!["DomainURL"] = ""
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with sub nil failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.updateUser(sub: "", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with email validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = ""
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with given_name validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = ""
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with family_name validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = ""
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with mobile number validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}}, {\"dataType\":\"MOBILE\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"mobile_number\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Mobile\",\"verificationRequired\":\"Given mobile is not verified.\",\"required\":\"Mobile is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = ""
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with birthdate validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"birthdate\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Birthdate\",\"verificationRequired\":\"Given Birthdate is not verified.\",\"required\":\"Birthdate is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = ""
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with provider validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = ""
                    registrationEntity.username = "abc"
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with username validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = ""
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
                
                it("call update user with custom field validation failure controller") {
                    
                    let controller = RegistrationController.shared
                    
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"birthdate\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Birthdate\",\"verificationRequired\":\"Given Birthdate is not verified.\",\"required\":\"Birthdate is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    
                    let error: WebAuthError = WebAuthError.shared
                    
                    self.stub(everything, failure(error as Error as NSError))
                    
                    let expect = self.expectation(description: "Expectation")
                    
                    let properties = DBHelper.shared.getPropertyFile()
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    registrationEntity.username = "abc"
                    registrationEntity.customFields = Dictionary<String, RegistrationCustomFieldsEntity>()
                    let city1 = RegistrationCustomFieldsEntity()
                    city1.dataType = "TEXT"
                    city1.id = "city1"
                    city1.key = "city1"
                    city1.readOnly = false
                    city1.value = ""
                    registrationEntity.customFields["city1"] = city1
                    
                    controller.registrationFields = entity.data
                    
                    controller.updateUser(sub: "jhagsdghasd", registrationEntity: registrationEntity, properties: properties!) {
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
