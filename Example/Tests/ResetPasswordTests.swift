//
//  ResetPasswordTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class ResetPasswordTests: QuickSpec {
    override func spec() {
        describe("Reset password Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Reset password test") {
                
                it("call initiate reset password with email from public") {
                    
                    cidaas.initiateResetPassword(requestId: "83242846274283", email: "abc@gmail.com") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.rprq)
                        }
                    }
                }
                
                it("call initiate reset password with email failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.initiateResetPassword(requestId: "83242846274283", email: "abc@gmail.com") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.rprq)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call initiate reset password with sms from public") {
                    
                    cidaas.initiateResetPassword(requestId: "83242846274283", mobile: "+919876543210") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.rprq)
                        }
                    }
                }
                
                it("call initiate reset password with sms failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.initiateResetPassword(requestId: "83242846274283", mobile: "+919876543210") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.rprq)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call handle reset password from public") {
                    
                    cidaas.handleResetPassword(rprq: "134234234", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.resetRequestId)
                        }
                    }
                }
                
                it("call handle reset password failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.handleResetPassword(rprq: "134234234", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.resetRequestId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call reset password from public") {
                    
                    cidaas.resetPassword(rprq: "234234234", exchangeId: "873642764", password: "123456", confirmPassword: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.reseted)
                        }
                    }
                }
                
                it("call reset password failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.resetPassword(rprq: "234234234", exchangeId: "873642764", password: "123456", confirmPassword: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.reseted)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}

