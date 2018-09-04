//
//  TenantInfoTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class TenantInfoTests: QuickSpec {
    override func spec() {
        describe("TenantInfo Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("TenantInfo test") {
                
                it("call getTenantInfo from public") {
                    cidaas.getTenantInfo() {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.tenant_name)
                        }
                    }
                }
                
                it("call getTenantInfo failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getTenantInfo() {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.tenant_name)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}
