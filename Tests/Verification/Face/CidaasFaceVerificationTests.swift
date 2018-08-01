//
//  CidaasFaceVerificationTests.swift
//  sdkiOSTests
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasFaceVerificationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var faceController = FaceVerificationController.shared
    var FaceService = FaceVerificationService.shared
    
    func testAuthenticateFaceResponseEntity() {
        var authzCodeEntity = AuthenticateFaceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"1231345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testEnrollFaceResponseEntity() {
        var authzCodeEntity = EnrollFaceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"2343453453\", \"trackingCode\":\"1231345\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(EnrollFaceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testInitiateFaceResponseEntity() {
        var authzCodeEntity = InitiateFaceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"2343453453\", \"current_status\":\"VERIFIED\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedFaceResponseEntity() {
        var authzCodeEntity = ScannedFaceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"2343453453\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(ScannedFaceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testSetupFaceResponseEntity() {
        var authzCodeEntity = SetupFaceResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"qrCode\":\"2343453453\", \"queryString\":\"1231345\", \"statusId\":\"2342343\", \"verifierId\":\"true\"}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            authzCodeEntity = try decoder.decode(SetupFaceResponseEntity.self, from: data)
            print(authzCodeEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(authzCodeEntity.success, true)
    }
    
    func testScannedFaceEntity() {
        let entity = ScannedFaceEntity()
        entity.statusId = "123123"
        entity.usage_pass = "13423453543"
        entity.deviceInfo = DeviceInfoModel()
        XCTAssertEqual(entity.usage_pass, "13423453543")
    }
    
    func testConfigureFace() {
        let photo = UIImage()
        self.cidaas.configureFaceRecognition(sub: "123", photo: photo) {
            switch $0 {
            case .success(let configureFaceSuccess):
                print("\nSub : \(configureFaceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithFace() {
        let photo = UIImage()
        self.cidaas.loginWithFaceRecognition(email: "abc@gmail.com", requestId: "123123", photo: photo, usageType: .PASSWORDLESS) {
            switch $0 {
            case .success(let loginWithFaceSuccess):
                print("\nSub : \(loginWithFaceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testConfigureFaceController() {
        let photo = UIImage()
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.faceController.configureFace(sub: "123", photo: photo, properties: properties) {
            switch $0 {
            case .success(let configureFaceSuccess):
                print("\nSub : \(configureFaceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testLoginWithFaceController() {
        let photo = UIImage()
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        self.faceController.loginWithFace(email: "abc@gmail.com", mobile: "", sub: "", trackId: "", requestId: "123123", photo: photo, usageType: .PASSWORDLESS, properties: properties) {
            switch $0 {
            case .success(let loginWithFaceSuccess):
                print("\nSub : \(loginWithFaceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testSetupFaceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let setupFaceEntity = SetupFaceEntity()
        setupFaceEntity.client_id = "12312313"
        
        self.FaceService.setupFace(accessToken: "asdasd23u23t7", setupFaceEntity: setupFaceEntity, properties: properties) {
            switch $0 {
            case .success(let configureFaceSuccess):
                print("\nStatus Id : \(configureFaceSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testEnrollFaceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        let enrollFaceEntity = EnrollFaceEntity()
        enrollFaceEntity.verifierPassword = "RED[12313]"
        enrollFaceEntity.statusId = "8672783462843"
        let photo = UIImage(named: "photo", in: Bundle(for: Cidaas.self), compatibleWith: nil)
        self.FaceService.enrollFace(accessToken: "1231231", photo: photo!, enrollFaceEntity: enrollFaceEntity, properties: properties) {
            switch $0 {
            case .success(let verifyFaceSuccess):
                print("\nSub : \(verifyFaceSuccess.data.sub)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testInitiateFaceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let initiateFaceEntity = InitiateFaceEntity()
        initiateFaceEntity.email = "abc@gmail.com"
        initiateFaceEntity.usageType = "PASSWORDLESS"
        
        self.FaceService.initiateFace(initiateFaceEntity: initiateFaceEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithFaceSuccess):
                print("\nStatus Id : \(loginWithFaceSuccess.data.statusId)")
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
    
    func testAuthenticateFaceService() {
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        let authenticateFaceEntity = AuthenticateFaceEntity()
        authenticateFaceEntity.verifierPassword = "RED[123]"
        authenticateFaceEntity.statusId = "134iuywe8723y4"
        
        let image = UIImage(named: "photo", in: Bundle(for: Cidaas.self), compatibleWith: nil)
        
        self.FaceService.authenticateFace(photo: image!, authenticateFaceEntity: authenticateFaceEntity, properties: properties) {
            switch $0 {
            case .success(let loginWithFaceSuccess):
                print(loginWithFaceSuccess.success)
                break
            case .failure(let error):
                print("\nError : \(error.errorMessage)")
                break
                
            }
        }
    }
}
