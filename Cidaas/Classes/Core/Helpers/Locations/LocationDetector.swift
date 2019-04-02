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
 
    public func updateLocation() {
        DBHelper.shared.setLocation(lat: latitude, lon: longitude)
    }
}
