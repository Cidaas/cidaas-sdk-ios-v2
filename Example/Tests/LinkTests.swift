//
//  LinkTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
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
                
                it("call get linked users failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getLinkedUsers(sub: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.identities)
                        }
                    }
                    
                    cidaas.readPropertyFile()
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
                
                it("call link account failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.linkAccount(master_sub: "3248628374234", sub_to_link: "873687546345") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.updated)
                        }
                    }
                    
                    cidaas.readPropertyFile()
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
                
                it("call unlink account failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.unlinkAccount(identityId: "134234234", sub: "84735637845") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.updated)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call read properties failure from public") {
                    
                    FileHelper.shared.filename = "xxx"
                    cidaas.readPropertyFile()
                    FileHelper.shared.filename = "Cidaas"
                    cidaas.ENABLE_PKCE = false
                    cidaas.readPropertyFile()
                    cidaas.ENABLE_PKCE = true
                }
            }
        }
    }
}
