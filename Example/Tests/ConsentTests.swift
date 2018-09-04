//
//  ConsentTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 03/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class ConsentTests: QuickSpec {
    override func spec() {
        describe("Consent Test cases") {
            
            let cidaas = Cidaas.shared
            
            context("Consent test") {
                
                it("call get consent details from public") {
                    
                    cidaas.getConsentDetails(consent_name: "default") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.name)
                        }
                    }
                }
                
                it("call get consent details failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getConsentDetails(consent_name: "default") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.name)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }
                
                it("call Login after consent from public") {
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "default"
                    consentEntity.accepted = true
                    consentEntity.sub = "13234234"
                    consentEntity.track_id = "87634875634"
                    consentEntity.version = "JHASJD"
                    
                    cidaas.loginAfterConsent(consentEntity: consentEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call Login after consent failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let consentEntity = ConsentEntity()
                    consentEntity.consent_name = "default"
                    consentEntity.accepted = true
                    consentEntity.sub = "13234234"
                    consentEntity.track_id = "87634875634"
                    consentEntity.version = "JHASJD"
                    
                    cidaas.loginAfterConsent(consentEntity: consentEntity) {
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
