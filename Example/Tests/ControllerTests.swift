//
//  ControllerTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 12/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas
import Mockingjay

class ControllerTests: QuickSpec {
    override func spec() {
        describe("Controller Test cases") {
//
            context("Controller test") {
                it("call initiate account verification controller") {

                    let controller = AccountVerificationViewController.shared

                    var entity = InitiateAccountVerificationResponseEntity()

                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"accvid\":\"123\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateAccountVerificationResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }

                    // construct body params
                    var bodyParams = Dictionary<String, Any>()

                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(entity)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }

                    self.stub(everything, json(bodyParams))

                    let expect = self.expectation(description: "Expectation")

                    let properties = DBHelper.shared.getPropertyFile()
                    let incomingData: InitiateAccountVerificationEntity = InitiateAccountVerificationEntity()
                    incomingData.requestId = "5c4da8c3-f9f4-4884-865a-5d79ac24a017"
                    incomingData.processingType = "CODE"
                    incomingData.verificationMedium = "email"
                    incomingData.sub = "fbcc87b7-c39d-4c0f-ad0c-716033903543"
                    incomingData.email = "muthu.va23+23@gmail.com"
                    incomingData.mobile = ""
                    incomingData.locale = "fr-FR"
                    controller.initiateAccountVerification(accountVerificationEntity: incomingData) { result in
                     switch result {
                     case .failure(let error):
                         print(error.errorMessage)
                         expect.fulfill()
                         break
                     case .success(let response):
                         print(response.success)
                         expect.fulfill()
                         break
                     }
                    }
                }
            }
        }
    }
}
