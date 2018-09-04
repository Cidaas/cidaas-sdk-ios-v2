//
//  SmartPushTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class SmartPushTests: QuickSpec {
    override func spec() {
        describe("SmartPush Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("SmartPush test") {
                
                it("call configure SmartPush from public") {
                    
                    cidaas.configureSmartPush(sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call login with SmartPush from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithSmartPush(passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call verify Smart push from public") {
                    
                    cidaas.verifySmartPush(randomNumber: "66", statusId: "382b6e72-3435-4724-8339-ea7907f253e9") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
            }
        }
    }
}
