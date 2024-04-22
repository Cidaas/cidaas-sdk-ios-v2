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
    
    // get device location address
    //    func getDeviceLocationAddress() -> String? {
    //        let locationManager = CLLocationManager()
    //
    //        // Check if location services are enabled
    //        guard CLLocationManager.locationServicesEnabled() else {
    //            return nil
    //        }
    //
    //        locationManager.requestWhenInUseAuthorization()
    //
    //        // Request permission to use location services
    //        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
    //            return nil
    //        }
    //
    //        guard let location = locationManager.location else {
    //            return nil
    //        }
    //
    //        let geocoder = CLGeocoder()
    //        var addressString: String?
    //
    //        geocoder.reverseGeocodeLocation(location) { placemarks, error in
    //            guard let placemark = placemarks?.first else {
    //                return
    //            }
    //
    //            // Construct the address using placemark's properties
    //            var address = ""
    //            if let subThoroughfare = placemark.subThoroughfare {
    //                address += "\(subThoroughfare) "
    //            }
    //            if let thoroughfare = placemark.thoroughfare {
    //                address += "\(thoroughfare), "
    //            }
    //            if let locality = placemark.locality {
    //                address += "\(locality), "
    //            }
    //            if let administrativeArea = placemark.administrativeArea {
    //                address += "\(administrativeArea) "
    //            }
    //            if let postalCode = placemark.postalCode {
    //                address += "\(postalCode)"
    //            }
    //
    //            addressString = address
    //        }
    //
    //        while addressString == nil {
    //            // Wait for the reverse geocoding to complete
    //            // This is not recommended in production code, as it blocks the main thread
    //            // You should use a completion handler instead
    //            RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.1))
    //        }
    //
    //        return addressString
    //    }
    
    //    public func getDeviceLocationAddress() -> String? {
    //        let locationManager = CLLocationManager()
    //
    //        // Check if location services are enabled
    //        guard CLLocationManager.locationServicesEnabled() else {
    //            return nil
    //        }
    //
    //        locationManager.requestWhenInUseAuthorization()
    //
    //        // Request permission to use location services
    //        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
    //            return nil
    //        }
    //
    //        let dispatchGroup = DispatchGroup()
    //        dispatchGroup.enter()
    //
    //        var addressString: String?
    //
    //        // Start location updates
    //        locationManager.startUpdatingLocation()
    //
    //        // Use didUpdateLocations delegate method to get location
    //        locationManager.delegate = LocationDelegate(completion: { location in
    //            if let location = location {
    //                let geocoder = CLGeocoder()
    //                geocoder.reverseGeocodeLocation(location) { placemarks, error in
    //                    guard let placemark = placemarks?.first else {
    //                        return
    //                    }
    //
    //                    // Construct the address using placemark's properties
    //                    var address = ""
    //                    if let subThoroughfare = placemark.subThoroughfare {
    //                        address += "\(subThoroughfare) "
    //                    }
    //                    if let thoroughfare = placemark.thoroughfare {
    //                        address += "\(thoroughfare), "
    //                    }
    //                    if let locality = placemark.locality {
    //                        address += "\(locality), "
    //                    }
    //                    if let administrativeArea = placemark.administrativeArea {
    //                        address += "\(administrativeArea) "
    //                    }
    //                    if let postalCode = placemark.postalCode {
    //                        address += "\(postalCode)"
    //                    }
    //
    //                    addressString = address
    //
    //                    // Leave the dispatch group when reverse geocoding is completed
    //                    dispatchGroup.leave()
    //                }
    //            } else {
    //                // Leave the dispatch group if location is nil
    //                dispatchGroup.leave()
    //            }
    //        })
    //
    //        // Wait for the reverse geocoding to complete
    //        dispatchGroup.wait()
    //
    //        return addressString
    //    }
    //
    //    class LocationDelegate: NSObject, CLLocationManagerDelegate {
    //        var completion: ((CLLocation?) -> Void)?
    //
    //        init(completion: @escaping (CLLocation?) -> Void) {
    //            self.completion = completion
    //        }
    //
    //        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //            completion?(locations.last)
    //            manager.stopUpdatingLocation() // Stop location updates once location is obtained
    //            manager.delegate = nil // Reset delegate to avoid retaining reference to self
    //        }
    //
    //        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //            completion?(nil)
    //            manager.stopUpdatingLocation() // Stop location updates if there's an error
    //            manager.delegate = nil // Reset delegate to avoid retaining reference to self
    //        }
    //    }
    
    
    /*
     public func getDeviceLocationAddress() -> String? {
     var addressString: String?
     
     let semaphore = DispatchSemaphore(value: 0)
     
     // Perform location services check asynchronously
     DispatchQueue.global(qos: .background).async {
     if CLLocationManager.locationServicesEnabled() {
     DispatchQueue.main.async {
     // Location services are enabled
     // Continue with authorization check
     addressString = self.checkLocationAuthorization()
     semaphore.signal() // Signal semaphore to unblock
     }
     } else {
     DispatchQueue.main.async {
     // Location services are not enabled
     semaphore.signal() // Signal semaphore to unblock
     }
     }
     }
     
     // Wait for the location services check to complete
     _ = semaphore.wait(timeout: .now() + 5) // Wait for 5 seconds
     
     return addressString
     }
     
     private func checkLocationAuthorization() -> String? {
     let locationManager = CLLocationManager()
     
     locationManager.requestWhenInUseAuthorization()
     
     // Request permission to use location services
     guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
     return nil
     }
     
     var addressString: String?
     
     let dispatchGroup = DispatchGroup()
     dispatchGroup.enter()
     
     // Start location updates
     locationManager.startUpdatingLocation()
     
     // Use didUpdateLocations delegate method to get location
     let delegate = LocationDelegate { location in
     if let location = location {
     let geocoder = CLGeocoder()
     geocoder.reverseGeocodeLocation(location) { placemarks, error in
     guard let placemark = placemarks?.first else {
     dispatchGroup.leave() // Leave the dispatch group to unblock
     return
     }
     
     // Construct the address using placemark's properties
     var address = ""
     if let subThoroughfare = placemark.subThoroughfare {
     address += "\(subThoroughfare) "
     }
     if let thoroughfare = placemark.thoroughfare {
     address += "\(thoroughfare), "
     }
     if let locality = placemark.locality {
     address += "\(locality), "
     }
     if let administrativeArea = placemark.administrativeArea {
     address += "\(administrativeArea) "
     }
     if let postalCode = placemark.postalCode {
     address += "\(postalCode)"
     }
     
     addressString = address
     
     dispatchGroup.leave() // Leave the dispatch group to unblock
     }
     } else {
     dispatchGroup.leave() // Leave the dispatch group to unblock
     }
     }
     locationManager.delegate = delegate
     
     // Wait for the reverse geocoding to complete
     _ = dispatchGroup.wait(timeout: .now() + 30) // Wait for 30 seconds
     
     locationManager.stopUpdatingLocation() // Stop location updates
     
     return addressString
     }
     
     class LocationDelegate: NSObject, CLLocationManagerDelegate {
     var completion: ((CLLocation?) -> Void)?
     
     init(completion: @escaping (CLLocation?) -> Void) {
     self.completion = completion
     }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     completion?(locations.last)
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
     completion?(nil)
     }
     }
     */
    
    public func getDeviceLocationAddress() -> String? {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check if location services are enabled
        guard CLLocationManager.locationServicesEnabled() else {
            return nil
        }
        
        // Request permission to use location services
        locationManager.requestWhenInUseAuthorization()
        
        var addressString: String?
        
        // Fetch location synchronously
        if let location = locationManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    // Construct address string from placemark
                    addressString = ""
                    if let subThoroughfare = placemark.subThoroughfare {
                        addressString? += subThoroughfare + " "
                    }
                    if let thoroughfare = placemark.thoroughfare {
                        addressString? += thoroughfare + ", "
                    }
                    if let locality = placemark.locality {
                        addressString? += locality + ", "
                    }
                    if let administrativeArea = placemark.administrativeArea {
                        addressString? += administrativeArea + " "
                    }
                    if let postalCode = placemark.postalCode {
                        addressString? += postalCode
                    }
                }
            }
        }
        
        return addressString
    }
    
    }

    
