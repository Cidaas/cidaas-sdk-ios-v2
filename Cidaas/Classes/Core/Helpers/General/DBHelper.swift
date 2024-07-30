//
//  DBHelper.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import CoreLocation

public class DBHelper : NSObject, CLLocationManagerDelegate {
    var location: CLLocation?
    
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
    
    // set enable back button
    public func setEnableBackButton(enableBackButton : Bool, key : String = "OAuthEnableBackButton") {
        userDefaults.set(enableBackButton, forKey: key)
        userDefaults.synchronize()
    }
    
    // get enable back button
    public func getEnableBackButton(key : String = "OAuthEnableBackButton") -> Bool {
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
            let userId = accessTokenModel.sub
            let data = try encoder.encode(accessTokenModel)
            let access_token_string = String(data : data, encoding : .utf8)
            userDefaults.set(access_token_string, forKey: "cidaas_user_details_\(userId)")
            userDefaults.synchronize()
        }
        catch {
            userDefaults.synchronize()
        }
    }
    
    // get access token
    public func getAccessToken(key : String) -> AccessTokenModel {
        let userId = key
        guard let value = userDefaults.object(forKey: "cidaas_user_details_\(userId)") else {
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
    
    // set user deviceId
    public func setUserDeviceId(userDeviceId : String, key : String = "OAuthUserDeviceId") {
        userDefaults.set(userDeviceId, forKey: key + "-user-device-id")
        userDefaults.synchronize()
    }
    
    // get user deviceId
    public func getUserDeviceId(key : String = "OAuthUserDeviceId") -> String {
        guard let value = userDefaults.object(forKey: key + "-user-device-id") else {
            return ""
        }
        return value as? String ?? ""
    }
    
    // set TOTP secret qrcode
    public func setTOTPSecret(secret : String, name: String, issuer: String, key : String = "OAuthTOTPSecret") {
        userDefaults.set("otpauth://totp?secret=\(secret)&name=\(name)&issuer=\(issuer)", forKey: key + "-totp")
        userDefaults.synchronize()
    }
    
    // get TOTP secret qrcode
    public func getTOTPSecret(key : String = "OAuthTOTPSecret") -> String {
        guard let value = userDefaults.object(forKey: key + "-totp") else {
            return ""
        }
        return value as? String ?? ""
    }
    
    // set location
    public func setLocation(lat: String, lon: String, key: String = "OAuthLocation") {
        userDefaults.set(lat + "-" + lon, forKey: key)
        userDefaults.synchronize()
    }
    
    // get location
    public func getLocation(key: String = "OAuthLocation") -> (String, String) {
        guard let value = userDefaults.object(forKey: key) else {
            return ("", "")
        }
        // split by hyphen
        let splittedLocation: [Substring] = (value as? String ?? "").split(separator: "-")
        if splittedLocation.count  > 1 {
            return (String(splittedLocation[0]), String(splittedLocation[1]))
        }
        return ("", "")
    }

    private var locationManager = CLLocationManager()
    private var lastKnownLocation: CLLocation?
    private var geocoder = CLGeocoder()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func getDeviceLocationAddress(completion: @escaping (String?) -> Void) {
        guard let lastKnownLocation = self.lastKnownLocation else {
            completion(nil)
            return
        }
        
        geocoder.reverseGeocodeLocation(lastKnownLocation) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let addressString = placemark.compactAddress
                completion(addressString)
            } else {
                completion(nil)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastKnownLocation = location
    }
    
}

extension CLPlacemark {
    var compactAddress: String {
        if let name = name {
            var result = name
            
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        return "Unknown"
    }
}
