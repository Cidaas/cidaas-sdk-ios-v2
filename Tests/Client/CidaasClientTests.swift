//
//  CidaasClientTests.swift
//  CidaasTests
//
//  Created by ganesh on 28/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasClientTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var clientController = ClientController.shared
    var clientService = ClientService.shared
    
    func testClientInfoEntity() {
        var clientInfoResponseEntity = ClientInfoResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"passwordless_enabled\":true,\"logo_uri\":\"https://www.cidaas.com/wp-content/uploads/2018/02/logo-black.png\",\"login_providers\":[\"facebook\",\"google\",\"linkedin\"],\"policy_uri\":\"\",\"tos_uri\":\"\",\"client_name\":\"Single Page WebApp (Don\'t Edit)\",\"captcha_site_key\":\"6LcNAk0UAAAAAFf90A1OZx8Fj4cJkts_Tnv9sz0k\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            clientInfoResponseEntity = try decoder.decode(ClientInfoResponseEntity.self, from: data)
            print(clientInfoResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(clientInfoResponseEntity.success, true)
    }
    
    func testClientErrorResponseEntity() {
        var authzCodeEntity = ClientInfoErrorResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"error\":{\"code\":12324, \"error\":\"error\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ClientInfoErrorResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testGetClientInfo() {
        self.cidaas.getClientInfo(requestId: "123456") {
            switch $0 {
            case .success(let clientInfoSuccess):
                print("\nClient Name : \(clientInfoSuccess.data.client_name)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetClientInfoController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.clientController.getClientInfo(requestId: "123456", properties: properties) {
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
    
    func testGetClientInfoService() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        self.clientService.getClientInfo(requestId: "123456", properties: properties) {
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
