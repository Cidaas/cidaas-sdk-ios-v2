//
//  CidaasRequestIdTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasRequestIdTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var requestIdController = RequestIdController.shared
    var requestIdService = RequestIdService.shared
    
    func testRequestIdEntity() {
        var requestIdResponseEntity = RequestIdResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"groupname\":\"default\",\"lang\":\"en;q=1.0\",\"view_type\":\"login\",\"requestId\":\"34584aa3-3bd7-43a6-913f-4dc12cd4500a\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            requestIdResponseEntity = try decoder.decode(RequestIdResponseEntity.self, from: data)
            print(requestIdResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(requestIdResponseEntity.success, true)
    }
    
    func testGetRequestId() {
        self.cidaas.getRequestId() {
            switch $0 {
            case .success(let requestIdSuccess):
                print("\nRequestId : \(requestIdSuccess.data.requestId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetRequestIdController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        properties["ClientId"] = "123123"
        properties["RedirectURL"] = "https://localmanagement.cidaas.de"
        
        self.requestIdController.getRequestId(properties: properties) {
            switch $0 {
            case .success(let requestIdSuccess):
                print("\nRequestId : \(requestIdSuccess.data.requestId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testGetRequestIdService() {
       
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        properties["ClientId"] = "123123"
        properties["RedirectURL"] = "https://localmanagement.cidaas.de"
        
        self.requestIdService.getRequestId(properties: properties) {
            switch $0 {
            case .success(let requestIdSuccess):
                print("\nRequestId : \(requestIdSuccess.data.requestId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
}
