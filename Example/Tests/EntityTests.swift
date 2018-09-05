//
//  EntityTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 05/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Cidaas

class EntityTests: QuickSpec {
    override func spec() {
        describe("Entity Test cases") {
            
            context("Entity test") {
                
                it("call account verification list response entity") {
                    var entity = AccountVerificationListResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"EMAIL\":false, \"MOBILE\":false, \"USER_NAME\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccountVerificationListResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate account verification response entity") {
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
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call verify account response entity") {
                    var entity = VerifyAccountResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(VerifyAccountResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call change password response entity") {
                    var entity = ChangePasswordResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"changed\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ChangePasswordResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call client info response entity") {
                    var entity = ClientInfoResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"passwordless_enabled\":true,\"logo_uri\":\"https://www.cidaas.com/wp-content/uploads/2018/02/logo-black.png\",\"login_providers\":[\"facebook\",\"google\",\"linkedin\"],\"policy_uri\":\"\",\"tos_uri\":\"\",\"client_name\":\"Single Page WebApp (Don\'t Edit)\",\"captcha_site_key\":\"6LcNAk0UAAAAAFf90A1OZx8Fj4cJkts_Tnv9sz0k\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ClientInfoResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call accept consent response entity") {
                    var entity = AcceptConsentResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":true}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AcceptConsentResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call consent details response entity") {
                    var entity = ConsentDetailsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sensitive\":true,\"policyUrl\":\"https://abc.com\",\"userAgreeText\":\"I agree\", \"description\":\"d\", \"name\":\"a\", \"language\":\"test\", \"consentReceiptID\":\"test\", \"collectionMethod\":\"test\", \"jurisdiction\":\"test\", \"enabled\":true, \"consent_type\":\"test\", \"status\":\"test\", \"spiCat\":[\"test\"], \"services\":[{\"service\":\"Demo\", \"purposes\":[{\"purpose\":\"Demo\", \"purposeCategory\":\"test\", \"consentType\":\"test\", \"piiCategory\":\"test\", \"primaryPurpose\":true, \"termination\":\"test\", \"thirdPartyDisclosure\":true, \"thirdPartyName\":\"test\"}]}], \"piiControllers\":[{\"piiController\":\"Demo\", \"onBehalf\":true, \"contact\":\"test\", \"email\":\"test\", \"phone\":\"test\", \"address\":{\"streetAddress\":\"Test\", \"addressCountry\":\"test\"}}], \"version\":\"test\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ConsentDetailsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call consent response entity") {
                    var entity = ConsentResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":\"asdasd\"}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ConsentResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call deduplication details response entity") {
                    var entity = DeduplicationDetailsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"email\":\"abc@gmail.com\", \"deduplicationList\":[{\"email\":\"ab@g.com\"}]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(DeduplicationDetailsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call client info response entity") {
                    var entity = ClientInfoErrorResponseEntity()
                    
                    let jsonString = "{\"success\":false,\"status\":400,\"error\":{\"code\":2001, \"error\":\"not found\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ClientInfoErrorResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, false)
                }
                
                it("call consent error response entity") {
                    var entity = ConsentErrorResponseEntity()
                    
                    let jsonString = "{\"success\":false,\"status\":400,\"error\":{\"code\":2001, \"error\":\"not found\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ConsentErrorResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, false)
                }
                
                it("call error response entity") {
                    var entity = ErrorResponseEntity()
                    
                    let jsonString = "{\"success\":false,\"status\":400,\"error\":{\"code\":2001, \"error\":\"not found\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ErrorResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, false)
                }
                
                it("call verification error response entity") {
                    var entity = VerificationErrorResponseEntity()
                    
                    let jsonString = "{\"success\":false,\"status\":400,\"error\":{\"code\":2001, \"error\":\"not found\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(VerificationErrorResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, false)
                }
                
                it("call login error response entity") {
                    var entity = LoginErrorResponseEntity()
                    
                    let jsonString = "{\"success\":false,\"status\":400,\"error\":{\"code\":2001, \"error\":\"not found\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginErrorResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, false)
                }
                
                it("call link account response entity") {
                    var entity = LinkAccountResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"updated\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LinkAccountResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call linked users list response entity") {
                    var entity = LinkedUserListResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"identities\":[{\"email\":\"ab@g.com\",\"provider\":\"SELF\",\"sub\":\"35464563t\",\"_id\":\"43tg345345345\"}]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LinkedUserListResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call access token entity") {
                    var entity = AccessTokenEntity()
                    
                    let jsonString = "{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AccessTokenEntity.self, from: data)
                        print(entity.sub)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.sub, "123234232")
                }
                
                it("call authz code entity") {
                    var entity = AuthzCodeEntity()
                    
                     let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"code\":\"83475837\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthzCodeEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call login response entity") {
                    var entity = LoginResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"123234232\",\"token_type\":\"BEARER\", \"expires_in\":86400,\"id_token_expires_in\":86400,\"access_token\":\"jdgfuygfdywe\",\"id_token\":\"jhgfjwguwgeyrwgeyrfwer\",\"refresh_token\":\"7tguegf\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(LoginResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call registration fields response entity") {
                    var entity = RegistrationFieldsResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"dataType\":\"EMAIL\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"email\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Email\",\"verificationRequired\":\"Given Email is not verified.\",\"required\":\"Email is Required\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"given_name\",\"fieldType\":\"SYSTEM\",\"order\":2,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"maxLength\":\"Givenname cannot be more than 150 chars\",\"required\":\"Given Name is Required\",\"name\":\"Given Name\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"family_name\",\"fieldType\":\"SYSTEM\",\"order\":3,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":150},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Family Name\",\"required\":\"Family Name is Required\",\"maxLength\":\"Family Name cannot be more than 150 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password\",\"fieldType\":\"SYSTEM\",\"order\":4,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Password\",\"required\":\"Password is Required\",\"maxLength\":\"Password cannot be more than 20 chars\"}},{\"dataType\":\"PASSWORD\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"password_echo\",\"fieldType\":\"SYSTEM\",\"order\":69,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":20,\"applyPasswordPoly\":false,\"matchWith\":\"Confirm Password Must Match with Password.\"},\"localeText\":{\"locale\":\"en-us\",\"language\":\"en\",\"name\":\"Confirm Password\",\"required\":\"Confirm Password is Required\",\"maxLength\":\"Confirm Password cannot be more than 20 chars\",\"matchWith\":\"Confirm Password Must Match with Password.\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"username\",\"fieldType\":\"SYSTEM\",\"order\":1,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"maxLength\":6,\"minLength\":5},\"localeText\":{\"minLength\":\"Username must be minimum of 5 characters\",\"required\":\"Username is Required\",\"verificationRequired\":\"Given Username is not verified.\",\"name\":\"Username\",\"language\":\"en\",\"locale\":\"en-us\"}},{\"dataType\":\"TEXT\",\"fieldGroup\":\"DEFAULT\",\"isGroupTitle\":false,\"fieldKey\":\"city1\",\"fieldType\":\"CUSTOM\",\"order\":66,\"readOnly\":false,\"required\":true,\"fieldDefinition\":{\"language\":\"en\",\"locale\":\"en-US\",\"name\":\"city1\",\"maxlength\":17,\"minlength\":16},\"localeText\":{\"locale\":\"en-US\",\"name\":\"city1\",\"required\":\"city1\",\"language\":\"en\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationFieldsResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call registration response entity") {
                    var entity = RegistrationResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"12345\", \"userStatus\":\"verified\", \"email_verified\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(RegistrationResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call update user response entity") {
                    var entity = UpdateUserResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"updated\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(UpdateUserResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call handle reset password response entity") {
                    var entity = HandleResetPasswordResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"exchangeId\":\"jhsdgfjhsdf\",\"resetRequestId\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(HandleResetPasswordResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate reset password response entity") {
                    var entity = InitiateResetPasswordResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reset_initiated\":true,\"rprq\":\"jhgsdfj\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateResetPasswordResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call reset password response entity") {
                    var entity = ResetPasswordResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"reseted\":true}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ResetPasswordResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call tenant info response entity") {
                    var entity = TenantInfoResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"tenant_name\":\"Demo\",\"allowLoginWith\":[\"Email\"]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(TenantInfoResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call user activity response entity") {
                    var entity = UserActivityResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":[{\"osName\":\"Demo\", \"socialIdentity\":{\"firstname\":\"Test\"}}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(UserActivityResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call upload image response entity") {
                    var entity = UploadImageResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":true}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(UploadImageResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call user info entity") {
                    var entity = UserInfoEntity()
                    
                    let jsonString = "{\"sub\":\"123234232\",\"given_name\":\"Test\", \"family_name\":\"Demo\", \"identities\":[{\"provider\":\"SELF\"}]}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(UserInfoEntity.self, from: data)
                        print(entity.sub)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.sub, "123234232")
                }
                
                it("call authenticate backupcode response entity") {
                    var entity = AuthenticateBackupcodeResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticateBackupcodeResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call authenticate TOTP response entity") {
                    var entity = AuthenticateTOTPResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticateTOTPResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call authenticate pattern response entity") {
                    var entity = AuthenticatePatternResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticatePatternResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call authenticate touch response entity") {
                    var entity = AuthenticateTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticateTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call authenticate push response entity") {
                    var entity = AuthenticatePushResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticatePushResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call authenticate face response entity") {
                    var entity = AuthenticateFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticateFaceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call authenticate voice response entity") {
                    var entity = AuthenticateVoiceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(AuthenticateVoiceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate backupcode response entity") {
                    var entity = InitiateBackupcodeResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateBackupcodeResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate email response entity") {
                    var entity = InitiateEmailResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateEmailResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate sms response entity") {
                    var entity = InitiateSMSResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateSMSResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate ivr response entity") {
                    var entity = InitiateIVRResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateIVRResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate TOTP response entity") {
                    var entity = InitiateTOTPResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateTOTPResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate pattern response entity") {
                    var entity = InitiatePatternResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiatePatternResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate touch response entity") {
                    var entity = InitiateTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate push response entity") {
                    var entity = InitiatePushResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiatePushResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate face response entity") {
                    var entity = InitiateFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateFaceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call initiate voice response entity") {
                    var entity = InitiateVoiceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(InitiateVoiceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup backupcode response entity") {
                    var entity = SetupBackupcodeResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\", \"backupCodes\":[{\"statusId\":\"jhagdfhjadf\", \"code\":\"567567\",\"usedDeviceInfo\":{\"userDeviceId\":\"jhasgdfhsdf\"}}]}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupBackupcodeResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup email response entity") {
                    var entity = SetupEmailResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupEmailResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup sms response entity") {
                    var entity = SetupSMSResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupSMSResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup ivr response entity") {
                    var entity = SetupIVRResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupIVRResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup TOTP response entity") {
                    var entity = SetupTOTPResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupTOTPResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup pattern response entity") {
                    var entity = SetupPatternResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupPatternResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup touch response entity") {
                    var entity = SetupTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup push response entity") {
                    var entity = SetupPushResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupPushResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup face response entity") {
                    var entity = SetupFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupFaceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call setup voice response entity") {
                    var entity = SetupVoiceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"statusId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(SetupVoiceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call scanned TOTP response entity") {
                    var entity = ScannedTOTPResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ScannedTOTPResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call scanned pattern response entity") {
                    var entity = ScannedPatternResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ScannedPatternResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call scanned touch response entity") {
                    var entity = ScannedTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ScannedTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call scanned push response entity") {
                    var entity = ScannedPushResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ScannedPushResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call scanned face response entity") {
                    var entity = ScannedFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ScannedFaceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call scanned voice response entity") {
                    var entity = ScannedVoiceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"userDeviceId\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(ScannedVoiceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call enroll TOTP response entity") {
                    var entity = EnrollTOTPResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollTOTPResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call enroll pattern response entity") {
                    var entity = EnrollPatternResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollPatternResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call enroll touch response entity") {
                    var entity = EnrollTouchResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollTouchResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call enroll push response entity") {
                    var entity = EnrollPushResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollPushResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call enroll face response entity") {
                    var entity = EnrollFaceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollFaceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
                it("call enroll voice response entity") {
                    var entity = EnrollVoiceResponseEntity()
                    
                    let jsonString = "{\"success\":true,\"status\":200,\"data\":{\"sub\":\"adfasdfasd\"}}"
                    let decoder = JSONDecoder()
                    do {
                        let data = jsonString.data(using: .utf8)!
                        // decode the json data to object
                        entity = try decoder.decode(EnrollVoiceResponseEntity.self, from: data)
                        print(entity.success)
                    }
                    catch(let error) {
                        print(error.localizedDescription)
                    }
                    XCTAssertEqual(entity.success, true)
                }
                
            }
        }
    }
}
