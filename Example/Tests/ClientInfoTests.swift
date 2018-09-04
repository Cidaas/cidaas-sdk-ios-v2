//
//  ClientInfoTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class ClientInfoTests: QuickSpec {
    override func spec() {
        describe("ClientInfo Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("ClientInfo test") {
                
                it("call getClientInfo from public") {
                    cidaas.getClientInfo(requestId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.client_name)
                        }
                    }
                }
                
                it("call getClientInfo failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getClientInfo(requestId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.client_name)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}
