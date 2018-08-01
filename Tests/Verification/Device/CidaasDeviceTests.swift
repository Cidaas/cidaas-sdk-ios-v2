//
//  CidaasDeviceTests.swift
//  CidaasTests
//
//  Created by ganesh on 30/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasDeviceTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    
    func testValidateDeviceEntity() {
        let validateDeviceEntity = ValidateDeviceEntity()
        validateDeviceEntity.access_verifier = "123123123"
        validateDeviceEntity.intermediate_verifiation_id = "1231231"
        validateDeviceEntity.statusId = "7826347"
        
        var bodyParams = Dictionary<String, Any>()
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(validateDeviceEntity)
            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
            print(bodyParams["statusId"]!)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
    }
    
    func testVerificationErrorResponseEntity() {
        var authzCodeEntity = VerificationErrorResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"error\":{\"code\":12324, \"error\":\"error\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(VerificationErrorResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testValidateDeviceResponseEntity() {
        var authzCodeEntity = ValidateDeviceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"usage_pass\":\"12324\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ValidateDeviceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
}
