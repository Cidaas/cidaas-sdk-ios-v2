//
//  CidaasDeduplicationTests.swift
//  CidaasTests
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasDeduplicationTests: XCTestCase {
    
    let ctrl = DeduplicationController()
    
    func testGetDeduplicationController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        ctrl.getDeduplicationDetails(track_id: "238762837467283", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.email)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testRegisterDeduplicationController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        ctrl.registerDeduplication(track_id: "238762837467283", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.sub)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testLoginDeduplicationController() {
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        ctrl.deduplicationLogin(requestId: "2342342342435", sub: "875636745", password: "123", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.sub)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
}
