//
//  HelperTests.swift
//  Cidaas_Tests
//
//  Created by ganesh on 06/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Cidaas

class HelperTests: QuickSpec {
    override func spec() {
        describe("Helper Test cases") {
            
            context("Helper test") {
                
                it("call remove white space") {
                    var str = " demo"
                    str = str.removingWhitespaces()
                    XCTAssertEqual(str, "demo")
                }
                
                it("call file not exception") {
                    _ = WebAuthError.shared.fileNotFoundException()
                }
                
                it("call no content in file exception") {
                    _ = WebAuthError.shared.noContentInFileException()
                }
                
                it("call notification timeout exception") {
                    _ = WebAuthError.shared.notificationTimeoutException()
                }
                
                it("call property missing exception") {
                    _ = WebAuthError.shared.propertyMissingException()
                }
                
                it("call conversion exception") {
                    _ = WebAuthError.shared.conversionException()
                }
                
                it("call service failure exception") {
                    _ = WebAuthError.shared.serviceFailureException(errorCode: 1001, errorMessage: "Error", statusCode: 400)
                }
                
                it("call login url missing exception") {
                    _ = WebAuthError.shared.loginURLMissingException()
                }
                
                it("call redirect url missing exception") {
                    _ = WebAuthError.shared.redirectURLMissingException()
                }
                
                it("call delegate missing exception") {
                    _ = WebAuthError.shared.delegateMissingException()
                }
                
                it("call user cancelled exception") {
                    _ = WebAuthError.shared.userCancelledException()
                }
                
                it("call code not found exception") {
                    _ = WebAuthError.shared.codeNotFoundException()
                }
                
                it("call empty callback exception") {
                    _ = WebAuthError.shared.emptyCallbackException()
                }
                
                it("call no user found exception") {
                    _ = WebAuthError.shared.noUserFoundException()
                }
                
                it("call set and get access token") {
                    let db = DBHelper.shared
                    let accessTokenModel = AccessTokenModel()
                    accessTokenModel.userId = "765q763572"
                    db.setAccessToken(accessTokenModel: accessTokenModel)
                    _ = db.getAccessToken(key: "765q763572")
                }
                
                it("call set and get user info") {
                    let db = DBHelper.shared
                    let userInfoModel = UserInfoModel()
                    userInfoModel.userId = "765q763572"
                    db.setUserInfo(userInfoModel: userInfoModel)
                    _ = db.getUserInfo(key: "765q763572")
                }
                
                it("call set and get totp secret") {
                    let db = DBHelper.shared
                    db.setTOTPSecret(qrcode: "765q763572")
                    _ = db.getTOTPSecret()
                }
                
                it("call params to dictionary converter") {
                    let file = FileHelper.shared
                    file.paramsToDictionaryConverter(domainURL: "https://demo.cidaas.de", clientId: "aksjdhakjsdhaijsd", redirectURL: "https://demo.cidaas.de", callback: { (response) in
                        
                    })
                }
                
                it("call params to dictionary converter with domain url empty") {
                    let file = FileHelper.shared
                    file.paramsToDictionaryConverter(domainURL: "", clientId: "aksjdhakjsdhaijsd", redirectURL: "https://demo.cidaas.de", callback: { (response) in
                        
                    })
                }
                
                it("call params to dictionary converter with client id empty") {
                    let file = FileHelper.shared
                    file.paramsToDictionaryConverter(domainURL: "https://demo.cidaas.de", clientId: "", redirectURL: "https://demo.cidaas.de", callback: { (response) in
                        
                    })
                }
                
                it("call get change password url") {
                    let url = URLHelper.shared
                    _ = url.getChangePasswordURL()
                }
                
                it("call get image upload url") {
                    let url = URLHelper.shared
                    _ = url.getImageUploadURL()
                }
                
                it("call get link user url") {
                    let url = URLHelper.shared
                    _ = url.getLinkUserURL()
                }
                
                it("call get unlink user url") {
                    let url = URLHelper.shared
                    _ = url.getUnlinkUserURL(identityId: "asdjhasdi")
                }
                
                it("call get linked users list url") {
                    let url = URLHelper.shared
                    _ = url.getLinkedUsersListURL(sub: "asdakjdkjs")
                }
                
                it("call get user info url") {
                    let url = URLHelper.shared
                    _ = url.getUserInfoURL()
                }
                
                it("call get user activity url") {
                    let url = URLHelper.shared
                    _ = url.getUserActivityURL()
                }
                
                it("call get setup voice url") {
                    let url = URLHelper.shared
                    _ = url.getSetupVoiceURL()
                }
                
                it("call get scanned voice url") {
                    let url = URLHelper.shared
                    _ = url.getScannedVoiceURL()
                }
                
                it("call get enroll voice url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollVoiceURL()
                }
                
                it("call get initiate voice url") {
                    let url = URLHelper.shared
                    _ = url.getInitiateVoiceURL()
                }
                
                it("call get setup face url") {
                    let url = URLHelper.shared
                    _ = url.getSetupFaceURL()
                }
                
                it("call get scanned face url") {
                    let url = URLHelper.shared
                    _ = url.getScannedFaceURL()
                }
                
                it("call get enroll face url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollFaceURL()
                }
                
                it("call get initiate face url") {
                    let url = URLHelper.shared
                    _ = url.getInitiateFaceURL()
                }
                
                it("call get setup push url") {
                    let url = URLHelper.shared
                    _ = url.getSetupPushURL()
                }
                
                it("call get scanned push url") {
                    let url = URLHelper.shared
                    _ = url.getScannedPushURL()
                }
                
                it("call get enroll push url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollPushURL()
                }
                
                it("call get initiate push url") {
                    let url = URLHelper.shared
                    _ = url.getInitiatePushURL()
                }
                
                it("call get setup touch url") {
                    let url = URLHelper.shared
                    _ = url.getSetupTouchIdURL()
                }
                
                it("call get scanned touch url") {
                    let url = URLHelper.shared
                    _ = url.getScannedTouchIdURL()
                }
                
                it("call get enroll touch url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollTouchIdURL()
                }
                
                it("call get initiate touch url") {
                    let url = URLHelper.shared
                    _ = url.getInitiateTouchIdURL()
                }
                
                it("call get setup pattern url") {
                    let url = URLHelper.shared
                    _ = url.getSetupPatternURL()
                }
                
                it("call get scanned pattern url") {
                    let url = URLHelper.shared
                    _ = url.getScannedPatternURL()
                }
                
                it("call get enroll pattern url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollPatternURL()
                }
                
                it("call get initiate pattern url") {
                    let url = URLHelper.shared
                    _ = url.getInitiatePatternURL()
                }
                
                it("call get update user url") {
                    let url = URLHelper.shared
                    _ = url.getUpdateUserURL(sub: "asdjhgasd")
                }
                
                it("call get authenticate backupcode url") {
                    let url = URLHelper.shared
                    _ = url.getAuthenticateBackupcodeURL()
                }
                
                it("call get authenticate TOTP url") {
                    let url = URLHelper.shared
                    _ = url.getAuthenticateTOTPURL()
                }
                
                it("call get mfa continue url") {
                    let url = URLHelper.shared
                    _ = url.getMFAContinueURL(trackId: "asjhgjahsd")
                }
                
                it("call get passwordless continue url") {
                    let url = URLHelper.shared
                    _ = url.getPasswordlessContinueURL()
                }
                
                it("call get setup totp url") {
                    let url = URLHelper.shared
                    _ = url.getSetupTOTPURL()
                }
                
                it("call get enroll totp url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollTOTPURL()
                }
                
                it("call get scanned totp url") {
                    let url = URLHelper.shared
                    _ = url.getScannedTOTPURL()
                }
                
                it("call get authenticate email url") {
                    let url = URLHelper.shared
                    _ = url.getAuthenticateEmailURL()
                }
                
                it("call get setup backupcode url") {
                    let url = URLHelper.shared
                    _ = url.getSetupBackupcodeURL()
                }
                
                it("call get enroll ivr url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollIVRURL()
                }
                
                it("call get enroll sms url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollSMSURL()
                }
                
                it("call get enroll email url") {
                    let url = URLHelper.shared
                    _ = url.getEnrollEmailURL()
                }
                
                it("call get setup ivr url") {
                    let url = URLHelper.shared
                    _ = url.getSetupIVRURL()
                }
                
                it("call get setup sms url") {
                    let url = URLHelper.shared
                    _ = url.getSetupSMSURL()
                }
                
                it("call get setup email url") {
                    let url = URLHelper.shared
                    _ = url.getSetupEmailURL()
                }
                
                it("call get consent url") {
                    let url = URLHelper.shared
                    _ = url.getConsentURL(consent_name: "adasd", version: 2)
                }
            }
        }
    }
}
