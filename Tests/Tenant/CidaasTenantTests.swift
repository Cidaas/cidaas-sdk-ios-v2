//
//  CidaasTenantTests.swift
//  CidaasTests
//
//  Created by ganesh on 28/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasTenantTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var tenantController = TenantController.shared
    var tenantService = TenantService.shared
    
    func testTenantInfoEntity() {
        var tenantInfoResponseEntity = TenantInfoResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"tenant_name\":\"Cidaas Developers\",\"allowLoginWith\":[\"EMAIL\",\"MOBILE\",\"USER_NAME\"]}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            tenantInfoResponseEntity = try decoder.decode(TenantInfoResponseEntity.self, from: data)
            print(tenantInfoResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(tenantInfoResponseEntity.success, true)
    }
    
    func testGetTenantInfo() {
        self.cidaas.getTenantInfo() {
            switch $0 {
            case .success(let tenantInfoSuccess):
                print("\nTenant Name : \(tenantInfoSuccess.data.tenant_name)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetTenantInfoController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.tenantController.getTenantInfo(properties: properties) {
            switch $0 {
            case .success(let tenantInfoSuccess):
                print("\nTenant Name : \(tenantInfoSuccess.data.tenant_name)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetTenantInfoService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.tenantService.getTenantInfo(properties: properties) {
            switch $0 {
            case .success(let tenantInfoSuccess):
                print("\nTenant Name : \(tenantInfoSuccess.data.tenant_name)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
}
