// https://github.com/Quick/Quick

import Quick
import Cidaas

class GeneralTests: QuickSpec {
    override func spec() {
        describe("basic common properties") {

            context("Properties Enabling") {

                let cidaas = Cidaas.shared
                let accessTokenController = AccessTokenController.shared

                it("enable logger") {
                    cidaas.ENABLE_LOG = true
                }

                it("enable pkce") {
                    cidaas.ENABLE_PKCE = true
                }

                it("set user device id") {
                    let userDeviceId = "72846746545"
                    let properties = DBHelper.shared.getPropertyFile()

                    DBHelper.shared.setUserDeviceId(userDeviceId: userDeviceId, key: properties!["DomainURL"]!)
                }

                it("call get user info from public") {

                    cidaas.getUserInfo(sub: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.email)
                        }
                    }
                }
                
                it("call get user info failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getUserInfo(sub: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.email)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call get access token by sub from public") {

                    cidaas.getAccessToken(sub: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call get access token by sub failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getAccessToken(sub: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call get access token by refresh token from public") {

                    cidaas.getAccessToken(refreshToken: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
                
                it("call get access token by refresh token failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getAccessToken(refreshToken: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call change password from public") {

                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "12345"
                    changePasswordEntity.new_password = "123456"
                    changePasswordEntity.confirm_password = "123456"

                    cidaas.changePassword(sub: "324243245356457", changePasswordEntity: changePasswordEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.changed)
                        }
                    }
                }
                
                it("call change password failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let changePasswordEntity = ChangePasswordEntity()
                    changePasswordEntity.old_password = "12345"
                    changePasswordEntity.new_password = "123456"
                    changePasswordEntity.confirm_password = "123456"
                    
                    cidaas.changePassword(sub: "324243245356457", changePasswordEntity: changePasswordEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.changed)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call get user activities from public") {

                    let userActivity = UserActivityEntity()
                    userActivity.skip = 0
                    userActivity.take = 10
                    userActivity.sub = "324243245356457"

                    cidaas.getUserActivity(userActivity: userActivity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data[0].browserName)
                        }
                    }
                }
                
                it("call get user activities failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    let userActivity = UserActivityEntity()
                    userActivity.skip = 0
                    userActivity.take = 10
                    userActivity.sub = "324243245356457"
                    
                    cidaas.getUserActivity(userActivity: userActivity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data[0].browserName)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call update user from public") {

                    let registrationEntity = RegistrationEntity()
                    registrationEntity.email = "abc@gmail.com"
                    registrationEntity.birthdate = "06/09/1993"
                    registrationEntity.family_name = "test"
                    registrationEntity.given_name = "demo"
                    registrationEntity.mobile_number = "+919876543210"
                    registrationEntity.password = "123456"
                    registrationEntity.password_echo = "123456"
                    registrationEntity.provider = "SELF"


                    cidaas.updateUser(sub: "324243245356457", registrationEntity: registrationEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.updated)
                        }
                    }
                }
                
                it("call update user failure from public") {
                    
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
                    
                    
                    cidaas.updateUser(sub: "324243245356457", registrationEntity: registrationEntity) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.updated)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call update user from public") {

                    cidaas.uploadImage(sub: "324243245356457", photo: UIImage(named: "conflictuser")!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                }
                
                it("call update user failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.uploadImage(sub: "324243245356457", photo: UIImage(named: "conflictuser")!) {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call get mfa list from public") {

                    cidaas.getMFAList(sub: "324243245356457") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                }
                
                it("call get mfa list failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getMFAList(sub: "324243245356457") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call get account verification list from public") {

                    cidaas.getAccountVerificationList(sub: "324243245356457") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                }
                
                it("call get account verification list failure from public") {
                    
                    DBHelper.shared.userDefaults.removeObject(forKey: "OAuthProperty")
                    
                    cidaas.getAccountVerificationList(sub: "324243245356457") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.success)
                        }
                    }
                    
                    cidaas.readPropertyFile()
                }

                it("call validate device from public") {
                    var userInfo = [AnyHashable : Any]()
                    userInfo["intermediate_id"] = "32487623742367"
                    cidaas.validateDevice(userInfo: userInfo)
                }
                
                it("call listen TOTP from public") {
                    cidaas.listenTOTP(sub: "324243245356457")
                }

                it("call cancel listening TOTP from public") {
                    cidaas.cancelListenTOTP()
                }
                
                it("call cancel listening TOTP from public") {
                    let useragent = CidaasUserAgentBuilder.shared.UAString()
                    print(useragent)
                }
                
                it("call get access token by code from controller") {
                    
                    accessTokenController.getAccessToken(code: "234234234234") {
                        switch $0 {
                        case .failure(let error):
                            print(error.errorMessage)
                        case .success(let response):
                            print(response.data.access_token)
                        }
                    }
                }
            }
        }
    }
}
