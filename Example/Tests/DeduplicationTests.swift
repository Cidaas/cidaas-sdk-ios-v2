//
//  DeduplicationTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas

class DeduplicationTests: QuickSpec {
    override func spec() {
        describe("Deduplication Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Deduplication test") {
                
                it("call get deduplication details from public") {
                    cidaas.getDeduplicationDetails(track_id: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.email)
                        }
                    }
                }
                
                it("call get deduplication details failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getDeduplicationDetails(track_id: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.email)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call register user from public") {
                    cidaas.registerUser(track_id: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.sub)
                        }
                    }
                }
                
                it("call register user failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.registerUser(track_id: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.sub)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with deduplication from public") {
                    cidaas.loginWithDeduplication(requestId: "987367516245613", sub: "456571345671232534656", password: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call login with deduplication failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.loginWithDeduplication(requestId: "987367516245613", sub: "456571345671232534656", password: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}
