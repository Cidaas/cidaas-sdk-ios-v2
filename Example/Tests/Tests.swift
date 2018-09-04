// https://github.com/Quick/Quick

import Quick
import Nimble
import Cidaas

class GeneralTests: QuickSpec {
    override func spec() {
        describe("basic common properties") {

            context("Properties Enabling") {

                let cidaas = Cidaas.shared

                it("enable logger") {
                    cidaas.ENABLE_LOG = true
                    expect(cidaas.ENABLE_LOG) == true
                }

                it("enable pkce") {
                    cidaas.ENABLE_PKCE = true
                    expect(cidaas.ENABLE_PKCE) == true
                }

                it("set fcm") {
                    cidaas.FCM_TOKEN = "adasdasdasdasddfskjahdukqguqe"
                    expect(cidaas.FCM_TOKEN) == "adasdasdasdasddfskjahdukqguqe"
                }

                it("set user device id") {
                    let userDeviceId = "72846746545"
                    let properties = DBHelper.shared.getPropertyFile()

                    DBHelper.shared.setUserDeviceId(userDeviceId: userDeviceId, key: properties!["DomainURL"]!)
                    expect(userDeviceId) == "72846746545"
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

                it("call listen TOTP from public") {
                    cidaas.listenTOTP(sub: "324243245356457")
                }

                it("call cancel listening TOTP from public") {
                    cidaas.cancelListenTOTP()
                }

                xit("will eventually pass") {
                    var time = "passing"

                    DispatchQueue.main.async {
                        time = "done"
                    }

                    waitUntil { done in
                        Thread.sleep(forTimeInterval: 0.5)
                        expect(time) == "done"

                        done()
                    }
                }
            }
        }
    }
}
