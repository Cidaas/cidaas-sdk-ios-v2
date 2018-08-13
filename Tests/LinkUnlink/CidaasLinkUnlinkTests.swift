//
//  CidaasLinkUnlinkTests.swift
//  CidaasTests
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasLinkUnlinkTests: XCTestCase {
    
    let ctrl = LinkUnlinkController.shared
    
    func testLinkAccountController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        ctrl.linkAccount(master_sub: "123", sub_to_link: "456", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.updated)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testGetLinkedUsersController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        ctrl.getLinkedUsers(sub: "234234234", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.identities)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testUnLinkAccountController() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        ctrl.unlinkAccount(identityId: "123", sub: "456", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.updated)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
}
