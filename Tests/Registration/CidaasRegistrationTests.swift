//
//  CidaasRegistrationTests.swift
//  CidaasTests
//
//  Created by ganesh on 30/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import XCTest
@testable import Cidaas

class CidaasRegistrationTests: XCTestCase {
    
    var cidaas = Cidaas.shared
    var registrationController = RegistrationController.shared
    var registrationService = RegistrationService.shared
    
    func testRegistrationFieldsResponseEntity() {
        var registrationFieldsResponseEntity = RegistrationFieldsResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            registrationFieldsResponseEntity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
            print(registrationFieldsResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(registrationFieldsResponseEntity.success, true)
    }
    
    func testRegistrationResponseEntity() {
        var registrationResponseEntity = RegistrationResponseEntity()
        
        let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"12345\", \"userStatus\":\"verified\", \"email_verified\":true}}"
        let decoder = JSONDecoder()
        do {
            let data = jsonString.data(using: .utf8)!
            // decode the json data to object
            registrationResponseEntity = try decoder.decode(RegistrationResponseEntity.self, from: data)
            print(registrationResponseEntity.success)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        XCTAssertEqual(registrationResponseEntity.success, true)
    }
    
    func testGetRegistrationFieldsController() {
        
        let loginEntity = LoginEntity()
        loginEntity.username = "abc@gmail.com"
        loginEntity.password = "123"
        loginEntity.username_type = "email"
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        registrationController.getRegistrationFields(locale: "", requestId: "123123", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testRegisterUserController() {
        
        let registrationEntity = RegistrationEntity()
        registrationEntity.email = "abc@gmail.com"
        registrationEntity.given_name = "abc"
        registrationEntity.family_name = "ajshgd"
        let age = RegistrationCustomFieldsEntity()
        age.id = "123123"
        age.dataType = "TEXT"
        age.key = "age"
        age.value = "25"
        registrationEntity.customFields = Dictionary<String, RegistrationCustomFieldsEntity>()
        registrationEntity.customFields["age"] = age
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        registrationController.registerUser(requestId: "113123", registrationEntity: registrationEntity, properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testGetRegistrationFieldsService() {
        
        let loginEntity = LoginEntity()
        loginEntity.username = "abc@gmail.com"
        loginEntity.password = "123"
        loginEntity.username_type = "email"
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        registrationService.getRegistrationFields(acceptlanguage: "en-US", requestId: "123123", properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
    
    func testRegisterUserService() {
        
        let registrationEntity = RegistrationEntity()
        registrationEntity.email = "abc@gmail.com"
        registrationEntity.given_name = "abc"
        registrationEntity.family_name = "ajshgd"
        registrationEntity.customFields = Dictionary<String, RegistrationCustomFieldsEntity>()
        
        var properties = Dictionary<String, String>()
        properties["DomainURL"] = "https://localmanagement.cidaas.de"
        
        registrationService.registerUser(requestId: "113123", registrationEntity: registrationEntity, properties: properties) {
            switch $0 {
            case .success(let response):
                print(response.success)
                break
            case .failure(let error):
                print(error.errorMessage)
                break
            }
        }
    }
}
