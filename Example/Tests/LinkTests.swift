//
//  LinkTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class LinkTests: QuickSpec {
    override func spec() {
        describe("Link Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Link test") {
                
                it("call get linked users from public") {
                    cidaas.getLinkedUsers(sub: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.identities)
                        }
                    }
                }
                
                it("call link account from public") {
                    cidaas.linkAccount(master_sub: "3248628374234", sub_to_link: "873687546345") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.updated)
                        }
                    }
                }
                
                it("call unlink account from public") {
                    cidaas.unlinkAccount(identityId: "134234234", sub: "84735637845") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.updated)
                        }
                    }
                }
            }
        }
    }
}
