//
//  CidaasTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var loginController = LoginController.shared
    var loginService = LoginService.shared
    
    func testLoginEntity() {
        let loginEntity = LoginEntity()
        loginEntity.username = "abc@gmail.com"
        loginEntity.password = "123"
        loginEntity.username_type = "email"
        
        var bodyParams = Dictionary<String, String>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(loginEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String> ?? Dictionary<String, String>()
            print(bodyParams["username"]!)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
        XCTAssertEqual(bodyParams["username"]!, "abc@gmail.com")
    }
    
    func testAuthzCodeResponseEntity() {
        var authzCodeEntity = AuthzCodeEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"123\",\"viewtype\":\"login\",\"grant_type\":\"authorization_code\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthzCodeEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testLoginResponseEntity() {
        var loginResponseEntity = LoginResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123\",\"access_token\":\"ey77uatdsu7236427\",\"id_token\":\"asdasdasd\",\"refresh_token\":\"12324wrwe3453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            loginResponseEntity = try decoder.decode(LoginResponseEntity.self, from: data)
            print(loginResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(loginResponseEntity.success, true)
    }
    
    func testLoginErrorResponseEntity() {
        var loginErrorResponseEntity = LoginErrorResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"error\":{\"sub\":\"123\",\"track_id\":\"ey77uatdsu7236427\",\"requestId\":\"asdasdasd\",\"error\":\"mfa_required\",\"client_id\":\"234234\",\"consent_version\":2,\"consent_name\":\"default\",\"suggested_url\":\"\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            loginErrorResponseEntity = try decoder.decode(LoginErrorResponseEntity.self, from: data)
            print(loginErrorResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(loginErrorResponseEntity.success, true)
    }
    
    func testTOTP() {
        let TOTP = TOTPVerificationController.shared
        let urlString = "otpauth://totp/Cidaas%20Developers:Ganesh%20kumar%20Kumar?secret=4bac873a-8c35-4b3a-8361-a938c86d5416&t=PATTERN&d=Ganesh%20kumar%20Kumar&issuer=Cidaas%20Developers&l=https%3A%2F%2Fdocs.cidaas.de%2Fassets%2Flogoss.png&sub=d55d2422-c237-46cb-a316-ed387083243e&resolverUrl=&rns=&cid=938c570e-7728-4fa3-b62f-5167f722c788&rurl=https%3A%2F%2Fnightlybuild.cidaas.de&st=129a597d-0989-4bee-ba61-06cf142f1168"
        print (TOTP.gettingTOTPCode(url: URL(string: urlString)!))
    }
    
    func testLoginWithCredentialsController() {
        
        let loginEntity = LoginEntity()
        loginEntity.username = "abc@gmail.com"
        loginEntity.password = "123"
        loginEntity.username_type = "email"
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        loginController.loginWithCredentials(requestId: "11324234", loginEntity: loginEntity, properties: properties) {
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
    
    func testLoginWithCredentialsService() {
        
        let loginEntity = LoginEntity()
        loginEntity.username = "abc@gmail.com"
        loginEntity.password = "123"
        loginEntity.username_type = "email"
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        loginService.loginWithCredentials(requestId: "11324234", loginEntity: loginEntity, properties: properties) {
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
