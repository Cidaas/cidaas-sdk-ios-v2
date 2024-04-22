//
//  File.swift
//  Cidaas
//
//  Created by ganesh on 18/02/19.
//

import Foundation
import CoreLocation

public class LocationDetector: NSObject, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager = CLLocationManager()
    var latitude: String = ""
    var longitude: String = ""
    
    public func startTracking() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation: CLLocation = locations[locations.count - 1]
        latitude = String(format: "%.6f", lastLocation.coordinate.latitude)
        longitude = String(format: "%.6f", lastLocation.coordinate.longitude)
        updateLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        latitude = ""
        longitude = ""
        updateLocation()
    }
 
    public func updateLocation() {
        DBHelper.shared.setLocation(lat: latitude, lon: longitude)
    }
    
//    public func checkIfLocationServicesIsEnabled() {
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined, .restricted, .denied:
//                print("Location services are enabled but not authorized.")
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Location services are enabled and authorized.")
//            @unknown default:
//                print("Location services status is unknown.")
//            }
//        } else {
//            print("Location services are disabled.")
//        }
//    }
    
    public func checkIfLocationServicesIsEnabled() {
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("Location services are enabled but not authorized.")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Location services are enabled and authorized.")
                @unknown default:
                    print("Location services status is unknown.")
                }
            } else {
                print("Location services are disabled.")
            }
        }
    }

}
