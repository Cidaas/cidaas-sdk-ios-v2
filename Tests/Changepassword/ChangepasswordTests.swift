//
//  ChangepasswordTests.swift
//  CidaasTests
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class ChangepasswordTests: XCTestCase {
    
    let changePasswordController = ChangepasswordController.shared
    
    func testChangePasswordController() {
        
        let changePasswordEntity = ChangePasswordEntity()
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        changePasswordController.changePassword(sub: "2867757635", changePasswordEntity: changePasswordEntity, properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.data.changed)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
}
