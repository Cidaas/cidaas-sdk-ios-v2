//
//  AccountVerificationTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class AccountVerificationTests: QuickSpec {
    override func spec() {
        describe("Account Verification Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Account Verification test") {
                
                it("call initiate email verification from public") {
                    
                    cidaas.initiateEmailVerification(requestId: "83242846274283", sub: "76752635") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.accvid)
                        }
                    }
                }
                
                it("call initiate sms verification from public") {
                    
                    cidaas.initiateSMSVerification(requestId: "83242846274283", sub: "76752635") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.accvid)
                        }
                    }
                }
                
                it("call initiate ivr verification from public") {
                    
                    cidaas.initiateIVRVerification(requestId: "83242846274283", sub: "76752635") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.accvid)
                        }
                    }
                }
                
                it("call verify account from public") {
                    
                    cidaas.verifyAccount(accvid: "38746238747234", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                }
            }
        }
    }
}

