//
//  RequestIdTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 28/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class RequestIdTests: QuickSpec {
    override func spec() {
        describe("RequestId Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("RequestId test") {
                
                it("call getRequestId from public") {
                    cidaas.getRequestId() {
                        switch $0 {
                            case .failure(let error):
                                print(error.errorMessage)
                            case .success(let response):
                                print(response.data.requestId)
                        }
                    }
                }
                
                it("call getRequestId failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getRequestId() {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.requestId)
                        }
                    }
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}

