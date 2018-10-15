//
//  LoginTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas

class LoginTests: QuickSpec {
    override func spec() {
        describe("Login Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Login test") {
                
                it("call Login with credentials from public") {
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123456"
                    loginEntity.username_type = "email"
                    
                    cidaas.loginWithCredentials(requestId: "382b6e72-3435-4724-8339-ea7907f253e9", loginEntity: loginEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call Login with credentials failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let loginEntity = LoginEntity()
                    loginEntity.username = "abc@gmail.com"
                    loginEntity.password = "123456"
                    loginEntity.username_type = "email"
                    
                    cidaas.loginWithCredentials(requestId: "382b6e72-3435-4724-8339-ea7907f253e9", loginEntity: loginEntity) {
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
