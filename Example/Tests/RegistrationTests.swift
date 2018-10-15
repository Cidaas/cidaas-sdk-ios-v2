//
//  RegistrationTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas

class RegistrationTests: QuickSpec {
    override func spec() {
        describe("Registration Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Registration test") {
                
                it("call get Registration details from public") {
                    cidaas.getRegistrationFields(requestId: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data[0].fieldKey)
                        }
                    }
                }
                
                it("call get Registration details failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getRegistrationFields(requestId: "34234234287628435") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data[0].fieldKey)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call register user from public") {
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    
                    cidaas.registerUser(requestId: "87236472534242342342", registrationEntity: registrationEntity) {
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
                    
                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"
                    
                    cidaas.registerUser(requestId: "87236472534242342342", registrationEntity: registrationEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.sub)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
            }
        }
    }
}
