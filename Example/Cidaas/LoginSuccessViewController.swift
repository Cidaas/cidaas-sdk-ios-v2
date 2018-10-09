//
//  LoginSuccessViewController.swift
//  Cidaas_Example
//
//  Created by ganesh on 05/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import CoreLocation
import Cidaas
import UserNotifications

class LoginSuccessViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    @IBOutlet var myTable: UITableView!
    
    // local variables
    var manager: CLLocationManager!
    var requestId: String = ""
    var accessToken: String = ""
    var sub: String = ""
    var cidaas = Cidaas.shared
    var userDefaults = UserDefaults.standard
    var deviceInfoEntity: DeviceInfoModel!
    var enteredLocationLatitude: CLLocationDegrees = 0.0
    var enteredLocationLongitude: CLLocationDegrees = 0.0
    var beaconSkipLevel = 0
    var locationSkipLevel = 0
    var beaconNotifyFlag = false
    var timer: Timer!
    
    var itemList : [Cart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTable.rowHeight = 132
        
        // get device information
        deviceInfoEntity = DBHelper.shared.getDeviceInfo()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        manager = CLLocationManager()
        
        UNUserNotificationCenter.current().delegate = self
        
        getItemList()
    }
    
    func getItemList() {
        var cart1 = Cart()
        cart1.image = UIImage(named: "iphone1")!
        cart1.body = "50% offer!!"
        cart1.color = "Grey"
        cart1.name = "iPhone XS MAX"
        cart1.prize = "Rs.46,000"
        cart1.rating = 4
        cart1.favourites = true
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "iphone2")!
        cart1.body = "EMI starts from Rs.7000/month"
        cart1.color = "Silver"
        cart1.name = "iPhone X"
        cart1.prize = "Rs.81,599"
        cart1.rating = 3
        cart1.favourites = false
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "honor9")!
        cart1.body = "No Cost EMI available"
        cart1.color = "Black"
        cart1.name = "Honor 9 Lite"
        cart1.prize = "Rs.14,599"
        cart1.rating = 5
        cart1.favourites = true
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "motog5")!
        cart1.body = "EMI not available"
        cart1.color = "Lunar Grey"
        cart1.name = "Moto G5S Plus"
        cart1.prize = "Rs.12,599"
        cart1.rating = 4
        cart1.favourites = false
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "iphone6splus")!
        cart1.body = "3% offer!!"
        cart1.color = "Grey"
        cart1.name = "iPhone 6S Plus"
        cart1.prize = "Rs.42,999"
        cart1.rating = 2
        cart1.favourites = false
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "iphonese")!
        cart1.body = "Save Rs.2,000"
        cart1.color = "Rose Gold"
        cart1.name = "iPhone SE"
        cart1.prize = "Rs.18,999"
        cart1.rating = 5
        cart1.favourites = true
        
        itemList.append(cart1)
        
        cart1 = Cart()
        cart1.image = UIImage(named: "oneplus3t")!
        cart1.body = "Save Rs.12,000"
        cart1.color = "Dark Black"
        cart1.name = "One Plus 3T"
        cart1.prize = "Rs.26,799"
        cart1.rating = 3
        cart1.favourites = true
        
        itemList.append(cart1)
        
        myTable.reloadData()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemsTableViewCell", for: indexPath) as! CartItemsTableViewCell
        cell.cartImage.image = itemList[indexPath.row].image
        cell.name.text = itemList[indexPath.row].name
        cell.color.text = itemList[indexPath.row].color
        cell.prize.text = itemList[indexPath.row].prize
        cell.body.text = itemList[indexPath.row].body
        cell.rating.rating = itemList[indexPath.row].rating
        if itemList[indexPath.row].favourites == true {
            cell.favourites.image = UIImage(named: "orangeheart")
        }
        else {
            cell.favourites.image = UIImage(named: "blackheart")
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sub = ((userDefaults.object(forKey: "sub") ?? "") as? String) ?? ""
        if sub == "" {
            self.navigationItem.rightBarButtonItem?.title = "Login"
        }
        else {
            self.navigationItem.rightBarButtonItem?.title = "Logout"
         
            getLocationList()
            getBeaconList()
        }
    }
    
    @IBAction func rightBarButtonItemClick(_ sender: Any) {
        if self.navigationItem.rightBarButtonItem?.title == "Logout" {
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
            self.navigationItem.rightBarButtonItem?.title = "Login"
            userDefaults.set("", forKey: "sub")
            userDefaults.set("", forKey: "sessionId")
            userDefaults.set([], forKey: "locationIds")
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func userInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        vc.sub = sub
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func startTracking(_ sender: Any) {
        
        // getting location list
        getLocationList()
        getBeaconList()
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
                
//                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
//                    self.manager.requestState(for: currRegion)
//                }

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
        
        
        // check if sessionid present
        let sessionId = ((userDefaults.object(forKey: "sessionId") ?? "") as? String) ?? ""
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
            
            emitLocation(locationEmission: locationEmission)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)  {
        
        
        guard region is CLBeaconRegion
            else {
                
                // log
                logw("Entered Geo Region \(region)", cname: "cidaaslocationtracking")
                
                let location = manager.location!
                
                self.enteredLocationLatitude = location.coordinate.latitude
                self.enteredLocationLongitude = location.coordinate.longitude
                
                // check if sessionid present
                var sessionId = ((userDefaults.object(forKey: "sessionId") ?? "") as? String) ?? ""
                var locationIds = ((userDefaults.object(forKey: "locationIds") ?? []) as? [String]) ?? []
                
                let check = locationIds.first(where: {$0 == region.identifier})
                if check == nil {
                    locationIds.append(region.identifier)
                }
                userDefaults.set(locationIds, forKey: "locationIds")
                
                // log
                logw("Entered Geo Region Session Id - \(String(describing: sessionId))", cname: "cidaaslocationtracking")
                logw("Entered Geo Region Location Ids - \(String(describing: locationIds))", cname: "cidaaslocationtracking")
                
                if sessionId == "" {
                    
                    generateNotification(title: "CID-KART", subTitle: "You are nearby CID-KART.", body: "Mobile phones offer maximum discount of 50%. Summer Sale!. Offer completed soon")
                    
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
                    
                    emitLocation(locationEmission: locationEmission)
                    userDefaults.set(sessionId, forKey: "sessionId")
                    userDefaults.set(region.identifier, forKey: region.identifier)
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
                    generateNotification(title: "CID-KART", subTitle: "iPhone XS MAX 50% Offer", body: "iPhone XS MAX with 50% offer on your Credit Card payment, No Cost EMI available. One day delivery! Hurry up!!!")
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
                let sessionId = ((userDefaults.object(forKey: "sessionId") ?? "") as? String) ?? ""
                let locationIds = ((userDefaults.object(forKey: "locationIds") ?? []) as? [String]) ?? []
                
                // log
                logw("Exited Geo Region Session Id - \(String(describing: sessionId))", cname: "cidaaslocationtracking")
                logw("Exited Geo Region Location Ids - \(String(describing: locationIds))", cname: "cidaaslocationtracking")
                
                let location = manager.location!
                
                let regionStarted = ((userDefaults.object(forKey: region.identifier) ?? "") as? String) ?? ""
                
                if sessionId != "" && regionStarted != "" {
                    
                    generateNotification(title: "CID-KART", subTitle: "Thank you for visiting CID-KART.", body: "")
                    
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
                    
                    emitLocation(locationEmission: locationEmission)
                    userDefaults.set("", forKey: "sessionId")
                    userDefaults.set("", forKey: region.identifier)
                }
                
                manager.stopUpdatingLocation()
                return
        }
        
        // log
        logw("Exited Beacon Region", cname: "cidaasbeacontracking")
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func getLocationList() {
        
        // log
        logw("Getting location list - Passes Sub \(sub)", cname: "cidaaslocationtracking")
        
        cidaas.getLocationList(sub: sub) {
            switch $0 {
                case .success(let result):
                    // log
                    logw("Getting location list response success  \(result.data.data)", cname: "cidaaslocationtracking")
                
                    self.configureLocation(data: result.data)
                
                case .failure(let error):
                    // log
                    logw("Getting location list response failure \(error.error)", cname: "cidaaslocationtracking")
            }
        }
    }
    
    func emitLocation(locationEmission: LocationEmission) {
        // log
        logw("Emitting location - Passes Sub \(sub)", cname: "cidaaslocationtracking")
        
        cidaas.emitLocation(locationEmission: locationEmission) {
            switch $0 {
            case .success(let result):
                // log
                logw("Location Emission response success  \(result.data.result)", cname: "cidaaslocationtracking")

            case .failure(let error):
                // log
                logw("Location Emission response failure \(error.error)", cname: "cidaaslocationtracking")
            }
        }
    }
    
    func getBeaconList() {
        
        // log
        logw("Getting Beacon list", cname: "cidaasbeacontracking")
        
        cidaas.getBeaconList() {
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
        
        cidaas.emitBeacon(beaconEmission: beaconEmission) {
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
