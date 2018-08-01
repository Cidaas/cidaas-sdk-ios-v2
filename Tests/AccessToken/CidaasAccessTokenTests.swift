//
//  CidaasAccessTokenTests.swift
//  CidaasTests
//
//  Created by ganesh on 30/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasAccessTokenTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var accessTokenController = AccessTokenController.shared
    var accessTokenService = AccessTokenService.shared
    
    func testGetTokenByCodeController() {
        accessTokenController.getAccessToken(code: "121234") {
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
    
    func testGetTokenBySubController() {
        accessTokenController.getAccessToken(sub: "1231231") {
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
    
    func testSaveAccessTokenController() {
        
        let accessTokenModel = AccessTokenModel.shared
        let accessTokenEntity = AccessTokenEntity()
        
        accessTokenController.saveAccessToken(accessTokenModel: accessTokenModel, accessTokenEntity: accessTokenEntity){
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
    
    func testGetTokenByCodeService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.accessTokenService.getAccessToken(code: "121234", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.access_token)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testGetTokenBySubService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.accessTokenService.getAccessToken(refreshToken: "8237462734", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.access_token)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
}
