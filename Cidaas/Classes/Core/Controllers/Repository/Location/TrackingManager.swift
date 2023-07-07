//
//  TrackingManager.swift
//  Cidaas
//
//  Created by ganesh on 11/10/18.
//

import UIKit
import CoreLocation
import UserNotifications

public class TrackingManager: NSObject, CLLocationManagerDelegate {
    
    public static var shared : TrackingManager = TrackingManager()
    
    // local variables
    var manager: CLLocationManager!
    var requestId: String = ""
    var accessToken: String = ""
    var sub: String = ""
    var userDefaults = UserDefaults.standard
    var deviceInfoEntity: DeviceInfoModel!
    var enteredLocationLatitude: CLLocationDegrees = 0.0
    var enteredLocationLongitude: CLLocationDegrees = 0.0
    var beaconSkipLevel = 0
    var locationSkipLevel = 0
    var beaconNotifyFlag = false
    var timer: Timer!
    var delegate: UIViewController!
    var properties: Dictionary<String, String> = Dictionary<String, String>()
    
    public override init() {
        // get device information
        deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        manager = CLLocationManager()
        super.init()
    }
    
    func generateNotification(title: String, subTitle: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let id = UUID().uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error ?? "")
        }
    }
    
    public func startTracking(sub: String, properties: Dictionary<String, String>) {
        self.properties = properties
        self.sub = sub
        getBeaconList()
    }
    
    public func stopTracking() {
        if timer != nil {
            self.timer.invalidate()
        }
        let monitoredRegions = self.manager.monitoredRegions
        self.manager.stopUpdatingLocation()
        for region in monitoredRegions {
            self.manager.stopMonitoring(for: region)
            if region is CLBeaconRegion {
                self.manager.stopRangingBeacons(in: region as! CLBeaconRegion)
            }
            locationManager(self.manager, didExitRegion: region)
        }
//        self.delegate.navigationItem.rightBarButtonItem?.title = "Login"
        userDefaults.removeObject(forKey: "locationIds")
        userDefaults.synchronize()
    }
    
    public func configureBeacon(data: [BeaconListResponseData]) {
        for beacon in data {
            for uniqueId in beacon.uniqueId {
                let uuid  = UUID(uuidString:uniqueId) ?? UUID.init(uuidString: "")
                let currRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "\(beacon.vendor)_\(uniqueId )")
                manager.distanceFilter = kCLDistanceFilterNone
                manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                currRegion.notifyOnEntry = true
                currRegion.notifyOnExit = true
                manager.requestAlwaysAuthorization()
                manager.delegate = self
                manager.pausesLocationUpdatesAutomatically = true
                manager.allowsBackgroundLocationUpdates = true
                manager.stopMonitoring(for: currRegion)
                manager.startMonitoring(for: currRegion)
                
                // log
                logw("Monitored Beacon Region \(currRegion)", cname: "cidaasbeacontracking")
                self.manager.requestState(for: currRegion)
                
            }
        }
    }
    
    public func configureLocation(data: LocationListResponseData) {
        
        for (index, _) in data.data.enumerated() {
            
            let branchLocation = data.data[index]
            
            let latitude: CLLocationDegrees = CLLocationDegrees(branchLocation.coordinates[1])
            let longitude: CLLocationDegrees = CLLocationDegrees(branchLocation.coordinates[0])
            
            // log
            logw("Monitored Locations \(latitude) \(longitude)", cname: "cidaaslocationtracking")
            
            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let radius: CLLocationDistance = CLLocationDistance(branchLocation.radius)
            let identifier: String = branchLocation.locationId
            let currRegion = CLCircularRegion(center: center, radius: radius, identifier: identifier)
            
            // log
            logw("Monitored Region \(currRegion)", cname: "cidaaslocationtracking")
            
            manager.distanceFilter = kCLDistanceFilterNone
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            currRegion.notifyOnEntry = true
            currRegion.notifyOnExit = true
            manager.requestAlwaysAuthorization()
            manager.delegate = self
            manager.pausesLocationUpdatesAutomatically = true
            manager.allowsBackgroundLocationUpdates = true
            manager.stopMonitoring(for: currRegion)
            manager.startMonitoring(for: currRegion)
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                self.manager.requestState(for: currRegion)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        guard region is CLBeaconRegion
            else {
                
                var current_state = ""
                if state == CLRegionState.inside {
                    current_state = "INSIDE"
                    
                    // log
                    logw("Enter Geo region called manually \(region)", cname: "cidaaslocationtracking")
                    
                    locationManager(manager, didEnterRegion: region)
                }
                else if state == CLRegionState.outside {
                    current_state = "OUTSIDE"
                    
                    // log
                    logw("Exit Geo region called manually \(region)", cname: "cidaaslocationtracking")
                    
                    locationManager(manager, didExitRegion: region)
                }
                
                // log
                logw("Check Geo region state \(current_state)", cname: "cidaaslocationtracking")
                
                return
        }
        
        var current_state = ""
        if state == CLRegionState.inside {
            current_state = "INSIDE"
            
            // log
            logw("Enter Beacon region called manually \(region)", cname: "cidaaslocationtracking")
            
            locationManager(manager, didEnterRegion: region)
        }
        else if state == CLRegionState.outside {
            current_state = "OUTSIDE"
            
            // log
            logw("Exit Beacon region called manually \(region)", cname: "cidaaslocationtracking")
            
            locationManager(manager, didExitRegion: region)
        }
        
        // log
        logw("Check Beacon region state \(current_state)", cname: "cidaaslocationtracking")
        
        return
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        guard region is CLBeaconRegion
            else {
                // log
                logw("Monitored Geo Started \(manager.monitoredRegions)", cname: "cidaaslocationtracking")
                return
        }
        
        // log
        logw("Monitored Beacon Started \(manager.monitoredRegions)", cname: "cidaaslocationtracking")
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        // log
        logw("Current Locations \(locValue.latitude) \(locValue.longitude)", cname: "cidaaslocationtracking")
        
        let location = manager.location!
        
        let coordinate0 = CLLocation(latitude: self.enteredLocationLatitude, longitude: self.enteredLocationLongitude)
        let coordinate1 = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        self.enteredLocationLatitude = location.coordinate.latitude
        self.enteredLocationLongitude = location.coordinate.longitude
        
        let distanceInMeters = coordinate0.distance(from: coordinate1) // result is in meters
        
        // log
        logw("Current Distance \(distanceInMeters)", cname: "cidaaslocationtracking")
        
//        if (distanceInMeters < 5) {
//            return
//        }
        
        if locationSkipLevel < 5 {
            locationSkipLevel = locationSkipLevel + 1
            return
        }
        
        locationSkipLevel = 0
        
        
        // get list of monitoring regions
        let regions = manager.monitoredRegions
        
        for region in regions {
            // check if sessionid present
            let sessionId = ((userDefaults.object(forKey: "\(region.identifier)_session_id") ?? "") as? String) ?? ""
            let locationIds = ((userDefaults.object(forKey: "locationIds") ?? []) as? [String]) ?? []
            
            // log
            logw("Update Locations Session Id - \(String(describing: sessionId))", cname: "cidaaslocationtracking")
            logw("Update Locations Location Ids - \(String(describing: locationIds))", cname: "cidaaslocationtracking")
            
            if sessionId != "" {
                
                // call enter region started call
                let locationEmission = LocationEmission()
                locationEmission.deviceId = deviceInfoEntity.deviceId
                locationEmission.locationIds = locationIds
                locationEmission.sessionId = sessionId
                locationEmission.status = "IN_PROGRESS"
                locationEmission.sub = sub
                locationEmission.geo = GeoLocation()
                locationEmission.geo.coordinates = []
                locationEmission.geo.coordinates.append(String(location.coordinate.longitude))
                locationEmission.geo.coordinates.append(String(location.coordinate.latitude))
                
                var bodyParams = Dictionary<String, Any>()
                
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(locationEmission)
                    bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                }
                catch(_) {
                }
                
                let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                
                // log
                logw("Update Locations Service body data response - \(String(describing: jsonString))", cname: "cidaaslocationtracking")
                
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)  {
        
        
        guard region is CLBeaconRegion
            else {
                
                // log
                logw("Entered Geo Region \(region)", cname: "cidaaslocationtracking")
                
                var location: CLLocation = CLLocation()
                
                if manager.location != nil {
                    location = manager.location!
                }
                
                self.enteredLocationLatitude = location.coordinate.latitude
                self.enteredLocationLongitude = location.coordinate.longitude
                
                // check if sessionid present
                var sessionId = ((userDefaults.object(forKey: ("\(region.identifier)_session_id")) ?? "") as? String) ?? ""
                var locationIds = ((userDefaults.object(forKey: "locationIds") ?? []) as? [String]) ?? []
                
                let check = locationIds.first(where: {$0 == region.identifier})
                if check == nil {
                    locationIds.append(region.identifier)
                }
                userDefaults.set(locationIds, forKey: "locationIds")
                userDefaults.synchronize()
                
                // log
                logw("Entered Geo Region Session Id - \(String(describing: sessionId))", cname: "cidaaslocationtracking")
                logw("Entered Geo Region Location Ids - \(String(describing: locationIds))", cname: "cidaaslocationtracking")
                
                if sessionId == "" {
                    
                    generateNotification(title: "Demo App", subTitle: "You are nearby the store.", body: "Summer Sale!. Offer completed soon")
                    
                    sessionId = UUID().uuidString
                    
                    // call enter region started call
                    let locationEmission = LocationEmission()
                    locationEmission.deviceId = deviceInfoEntity.deviceId
                    locationEmission.locationIds = locationIds
                    locationEmission.sessionId = sessionId
                    locationEmission.status = "STARTED"
                    locationEmission.sub = sub
                    locationEmission.geo = GeoLocation()
                    locationEmission.geo.coordinates = []
                    locationEmission.geo.coordinates.append(String(location.coordinate.longitude))
                    locationEmission.geo.coordinates.append(String(location.coordinate.latitude))
                    
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(locationEmission)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(_) {
                    }
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams, options: [])
                    let jsonString = String(data: jsonData!, encoding: .utf8)
                    
                    // log
                    logw("Entered Region Service body data response - \(String(describing: jsonString))", cname: "cidaaslocationtracking")
                    
                    userDefaults.set(sessionId, forKey: ("\(region.identifier)_session_id"))
                    userDefaults.set(region.identifier, forKey: region.identifier)
                    userDefaults.synchronize()
                }
                
                manager.startUpdatingLocation()
                return
        }
        
        // log
        logw("Entered Beacon Region", cname: "cidaasbeacontracking")
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let location = manager.location!
        
        if beaconSkipLevel < 5 {
            beaconSkipLevel = beaconSkipLevel + 1
            return
        }
        
        beaconSkipLevel = 0
        
        for beacon in beacons {
            
            if beacon.accuracy > 0.0 {
                
                let beaconEmission = BeaconEmission()
                beaconEmission.beacon = BeaconLocation()
                beaconEmission.beacon.uniqueId = region.proximityUUID.uuidString
                beaconEmission.beacon.major = String(describing: beacon.major)
                beaconEmission.beacon.minor = String(describing: beacon.minor)
                beaconEmission.deviceId = deviceInfoEntity.deviceId
                beaconEmission.distance = Float(beacon.accuracy)
                beaconEmission.geo = GeoLocation()
                beaconEmission.geo.coordinates = []
                beaconEmission.geo.coordinates.append(String(location.coordinate.longitude))
                beaconEmission.geo.coordinates.append(String(location.coordinate.latitude))
                beaconEmission.sub = sub
                
                var bodyParams = Dictionary<String, Any>()
                
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(beaconEmission)
                    bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                }
                catch(_) {
                }
                
                let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                
                // log
                logw("Ranging Beacons Service body data response - \(String(describing: jsonString))", cname: "cidaasbeacontracking")
                
                if beaconNotifyFlag == false {
                    self.beaconNotifyFlag = true
                    generateNotification(title: "Demo App", subTitle: "", body: "Few available")
                }
                
                emitBeacon(beaconEmission: beaconEmission)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        guard region is CLBeaconRegion
            else {
                
                // log
                logw("Exited Geo Region \(region)", cname: "cidaaslocationtracking")
                
                // check if sessionid present
                let sessionId = ((userDefaults.object(forKey: ("\(region.identifier)_session_id")) ?? "") as? String) ?? ""
                let locationIds = ((userDefaults.object(forKey: "locationIds") ?? []) as? [String]) ?? []
                
                // log
                logw("Exited Geo Region Session Id - \(String(describing: sessionId))", cname: "cidaaslocationtracking")
                logw("Exited Geo Region Location Ids - \(String(describing: locationIds))", cname: "cidaaslocationtracking")
                
                var location: CLLocation = CLLocation()
                
                if (manager.location != nil) {
                    location = manager.location!
                }
                
                let regionStarted = ((userDefaults.object(forKey: region.identifier) ?? "") as? String) ?? ""
                
                if sessionId != "" && regionStarted != "" {
                    
                    manager.stopUpdatingLocation()
                    
                    generateNotification(title: "Demo App", subTitle: "Thank you for visiting us.", body: "")
                    
                    // call enter region started call
                    let locationEmission = LocationEmission()
                    locationEmission.deviceId = deviceInfoEntity.deviceId
                    locationEmission.locationIds = locationIds
                    locationEmission.sessionId = sessionId
                    locationEmission.status = "ENDED"
                    locationEmission.sub = sub
                    locationEmission.geo = GeoLocation()
                    locationEmission.geo.coordinates = []
                    locationEmission.geo.coordinates.append(String(location.coordinate.longitude))
                    locationEmission.geo.coordinates.append(String(location.coordinate.latitude))
                    
                    var bodyParams = Dictionary<String, Any>()
                    
                    do {
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(locationEmission)
                        bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
                    }
                    catch(_) {
                    }
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams, options: [])
                    let jsonString = String(data: jsonData!, encoding: .utf8)
                    
                    // log
                    logw("Exited Region Service body data response - \(String(describing: jsonString))", cname: "cidaaslocationtracking")
                    
                    userDefaults.removeObject(forKey: ("\(region.identifier)_session_id"))
                    let check = locationIds.filter({$0 != region.identifier})
                    userDefaults.set(check, forKey: "locationIds")
                    userDefaults.removeObject(forKey: region.identifier)
                    userDefaults.synchronize()
                }
                return
        }
        
        // log
        logw("Exited Beacon Region", cname: "cidaasbeacontracking")
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func getBeaconList() {
        
        // log
        logw("Getting Beacon list", cname: "cidaasbeacontracking")
        
        LocationController.shared.getBeaconList(properties: self.properties) {
            switch $0 {
            case .success(let result):
                // log
                logw("Getting Beacon list response success  \(result.data)", cname: "cidaasbeacontracking")
                
                self.configureBeacon(data: result.data)
                
            case .failure(let error):
                // log
                logw("Getting Beacon list response failure \(error.error)", cname: "cidaasbeacontracking")
            }
        }
    }
    
    func emitBeacon(beaconEmission: BeaconEmission) {
        // log
        logw("Emiting Beacon - Passes Sub \(sub)", cname: "cidaasbeacontracking")
        
        LocationController.shared.emitBeacon(beaconEmission: beaconEmission, properties: self.properties) {
            switch $0 {
            case .success(let result):
                // log
                logw("Beacon Emission response success  \(result.data.result)", cname: "cidaasbeacontracking")
                
            case .failure(let error):
                // log
                logw("Beacon Emission response failure \(error.error)", cname: "cidaasbeacontracking")
            }
        }
    }
    
}
