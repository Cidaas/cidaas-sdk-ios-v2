//
//  EmailTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class EmailTests: QuickSpec {
    override func spec() {
        describe("Email Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Email test") {
                
                it("call configureEmail from public") {
                    
                    cidaas.configureEmail(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call configureEmail failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.configureEmail(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call enrollEmail from public") {
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call enrollEmail failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.enrollEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call login with email from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                }
                
                it("call login with email failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithEmail(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.statusId)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call verify email from public") {
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifyEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call verify email failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    EmailVerificationController.shared.sub = "asdasdasd"
                    
                    cidaas.verifyEmail(statusId: "766734563", code: "123456") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}
