//
//  CidaasGeneralTests.swift
//  CidaasTests
//
//  Created by ganesh on 31/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasGeneralTests: XCTestCase {
    
    var entityToModelConverter = EntityToModelConverter.shared
    
    func testAccessTokenEntityToAccessTokenModel() {
        
        let accessTokenEntity = AccessTokenEntity()
        accessTokenEntity.access_token = "asdasd"
        accessTokenEntity.expires_in = 0
        accessTokenEntity.id_token = "adasd"
        accessTokenEntity.id_token_expires_in = 0
        accessTokenEntity.refresh_token = "ieyq8guasdgad"
        accessTokenEntity.sub = "adsasd"
        accessTokenEntity.token_type = "asdasdasdasdfsdf"
        entityToModelConverter.accessTokenEntityToAccessTokenModel(accessTokenEntity: accessTokenEntity) { (accessTokenModel) in
            XCTAssertEqual(accessTokenModel.userId, accessTokenEntity.sub)
        }
    }
    
    func testAccessTokenModelToAccessTokenEntity() {
        
        let accessTokenModel = AccessTokenModel()
        accessTokenModel.accessToken = "asdasd"
        accessTokenModel.expiresIn = 0
        accessTokenModel.idToken = "adasd"
        accessTokenModel.seconds = 0
        accessTokenModel.refreshToken = "ieyq8guasdgad"
        accessTokenModel.userId = "adsasd"
        accessTokenModel.scope = "asdasdasdasdfsdf"
        entityToModelConverter.accessTokenModelToAccessTokenEntity(accessTokenModel: accessTokenModel) { (accessTokenEntity) in
            XCTAssertEqual(accessTokenEntity.sub, accessTokenModel.userId)
        }
    }
    
    func testLogs() {
        DBHelper.shared.setEnableLog(enableLog: true)
        logw("Welcome", cname: "cidaas-test-logs")
    }
    
    func testPKCEFlow() {
        let generator : OAuthChallengeGenerator = OAuthChallengeGenerator()
        print(generator.challenge)
        print(generator.method)
        print(generator.verifier)
    }
    
    func testUserInfoModel() {
        let userInfo = UserInfoModel.shared
        userInfo.active = true
        userInfo.displayName = "test"
        userInfo.email = "abc@gmail.com"
        userInfo.emailVerified = true
        userInfo.firstName = "asd"
        userInfo.lastName = "asddf"
        userInfo.mobile = "+921929332"
        userInfo.mobileNoVerified = true
        userInfo.provider = "self"
        userInfo.userId = "8idugusdf"
        userInfo.userName = "abc"
        
        XCTAssertEqual(userInfo.userName, "abc")
    }
    
//    func testUserInfoEntity() {
//        let userInfo = UserInfoEntity()
//        userInfo.active = true
//        userInfo.displayName = "test"
//        userInfo.email = "abc@gmail.com"
//        userInfo.emailVerified = true
//        userInfo.firstname = "asd"
//        userInfo.lastname = "asddf"
//        userInfo.mobile = "+921929332"
//        userInfo.mobileNoVerified = true
//        userInfo.provider = "self"
//        userInfo.ssoId = "8idugusdf"
//        userInfo.username = "abc"
//
//        XCTAssertEqual(userInfo.username, "abc")
//    }
    
    func testErrorResponseEntity() {
        var authzCodeEntity = ErrorResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"error\":{\"code\":12324, \"error\":\"error\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
}
