//
//  DBHelper.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class DBHelper : NSObject {
    
    // shared instance
    public static var shared : DBHelper = DBHelper()
    
    // local variables
    public var userDefaults = UserDefaults.standard
    
    // set enable log
    public func setEnableLog(enableLog : Bool, key : String = "OAuthEnableLog") {
        userDefaults.set(enableLog, forKey: key)
        userDefaults.synchronize()
    }
    
    // get enable log
    public func getEnableLog(key : String = "OAuthEnableLog") -> Bool {
        return ((userDefaults.object(forKey: key) ?? false) as? Bool) ?? false
    }
    
    // set enable pkce
    public func setEnablePkce(enablePkce : Bool, key : String = "OAuthEnablePkce") {
        userDefaults.set(enablePkce, forKey: key)
        userDefaults.synchronize()
    }
    
    // get enable pkce
    public func getEnablePkce(key : String = "OAuthEnablePkce") -> Bool {
        return ((userDefaults.object(forKey: key) ?? false) as? Bool) ?? false
    }
    
    // set FCM token
    public func setFCM(fcmToken : String, key : String = "OAuthFCM") {
        userDefaults.set(fcmToken, forKey: key)
        userDefaults.synchronize()
    }
    
    // get FCM token
    public func getFCM(key : String = "OAuthFCM") -> String {
        return ((userDefaults.object(forKey: key) ?? "") as? String) ?? ""
    }
    
    // set property file
    public func setPropertyFile(properties : Dictionary<String, String>?, key : String = "OAuthProperty") {
        userDefaults.set(properties, forKey: key)
        userDefaults.synchronize()
    }
    
    // get property file
    public func getPropertyFile(key : String = "OAuthProperty") -> Dictionary<String, String>? {
        guard let value = userDefaults.object(forKey: key) else {
            return nil
        }
        return value as? Dictionary<String, String> ?? nil
    }
    
    // set device info
    public func setDeviceInfo(deviceInfo : DeviceInfoModel, key : String = "OAuthDeviceInfo") {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(deviceInfo)
            let device_string = String(data: data, encoding: .utf8)
            userDefaults.set(device_string, forKey: key)
            userDefaults.synchronize()
        }
        catch {
            userDefaults.synchronize()
        }
    }
    
    // get device info
    public func getDeviceInfo(key : String = "OAuthDeviceInfo") -> DeviceInfoModel {
        guard let value = userDefaults.object(forKey: key) else {
            return DeviceInfoModel()
        }
        let device_string = value as? String ?? ""
        let decoder = JSONDecoder()
        do {
            let data = device_string.data(using: .utf8)!
            let deviceInfoEntity = try decoder.decode(DeviceInfoModel.self, from: data)
            return deviceInfoEntity
        }
        catch {
            return DeviceInfoModel()
        }
    }
    
    // set access token
    public func setAccessToken(accessTokenModel : AccessTokenModel) {
        let encoder = JSONEncoder()
        do {
            let userId = accessTokenModel.userId
            let data = try encoder.encode(accessTokenModel)
            let access_token_string = String(data : data, encoding : .utf8)
            userDefaults.set(access_token_string, forKey: userId)
            userDefaults.synchronize()
        }
        catch {
            userDefaults.synchronize()
        }
    }
    
    // set user info
    public func setUserInfo(userInfoModel : UserInfoModel) {
        let encoder = JSONEncoder()
        do {
            let userId = userInfoModel.userId
            let data = try encoder.encode(userInfoModel)
            let user_info_string = String(data : data, encoding : .utf8)
            userDefaults.set(user_info_string, forKey: userId)
            userDefaults.synchronize()
        }
        catch {
            userDefaults.synchronize()
        }
    }
    
    // get access token
    public func getAccessToken(key : String) -> AccessTokenModel {
        let userId = key
        guard let value = userDefaults.object(forKey: userId) else {
            return AccessTokenModel()
        }
        let access_token_string = value as? String ?? ""
        let decoder = JSONDecoder()
        do {
            let data = access_token_string.data(using: .utf8)!
            let accessTokenModel = try decoder.decode(AccessTokenModel.self, from: data)
            return accessTokenModel
        }
        catch {
            return AccessTokenModel()
        }
    }
    
    // get user info
    public func getUserInfo(key : String) -> UserInfoModel? {
        let userId = key
        guard let value = userDefaults.object(forKey: userId) else {
            return nil
        }
        let user_info_string = value as? String ?? ""
        let decoder = JSONDecoder()
        do {
            let data = user_info_string.data(using: .utf8)!
            let userInfoModel = try decoder.decode(UserInfoModel.self, from: data)
            return userInfoModel
        }
        catch {
            return nil
        }
    }
    
    // set user deviceId
    public func setUserDeviceId(userDeviceId : String, key : String = "OAuthUserDeviceId") {
        userDefaults.set(userDeviceId, forKey: key)
        userDefaults.synchronize()
    }
    
    // get user deviceId
    public func getUserDeviceId(key : String = "OAuthUserDeviceId") -> String {
        guard let value = userDefaults.object(forKey: key) else {
            return ""
        }
        return value as? String ?? ""
    }
    
    // set TOTP secret qrcode
    public func setTOTPSecret(qrcode : String, key : String = "OAuthTOTPSecret") {
        userDefaults.set(qrcode, forKey: key)
        userDefaults.synchronize()
    }
    
    // get TOTP secret qrcode
    public func getTOTPSecret(key : String = "OAuthTOTPSecret") -> String {
        guard let value = userDefaults.object(forKey: key) else {
            return ""
        }
        return value as? String ?? ""
    }
}
