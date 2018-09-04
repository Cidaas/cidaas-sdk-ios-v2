//
//  FaceTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class FaceTests: QuickSpec {
    override func spec() {
        describe("FaceRecognition Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("FaceRecognition test") {
                
                it("call configure FaceRecognition from public") {
                    
                    cidaas.configureFaceRecognition(photo: UIImage(named: "conflictuser")!, sub: "87267324") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.trackingCode)
                        }
                    }
                }
                
                it("call login with FaceRecognition from public") {
                    
                    let passwordlessEntity = PasswordlessEntity()
                    passwordlessEntity.email = "abc@gmail.com"
                    passwordlessEntity.mobile = "+919876543210"
                    passwordlessEntity.requestId = "382b6e72-3435-4724-8339-ea7907f253e9"
                    passwordlessEntity.sub = "87236482734"
                    passwordlessEntity.usageType = UsageTypes.MFA.rawValue
                    passwordlessEntity.trackId = "873472873482"
                    
                    cidaas.loginWithFaceRecognition(photo: UIImage(named: "conflictuser")!, passwordlessEntity: passwordlessEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call verify Face from public") {
                    
                    cidaas.verifyFace(photo: UIImage(named: "conflictuser")!, statusId: "382b6e72-3435-4724-8339-ea7907f253e9") {
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

