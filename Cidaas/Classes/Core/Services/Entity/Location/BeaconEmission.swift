//
//  BeaconEmission.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation

public class BeaconEmission : Codable {
    public var deviceId : String = ""
    public var distance : Float = 0.0
    public var sub : String = ""
    public var geo : GeoLocation = GeoLocation()
    public var beacon : BeaconLocation = BeaconLocation()
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId) ?? ""
        self.distance = try container.decodeIfPresent(Float.self, forKey: .distance) ?? 0.0
        self.geo = try container.decodeIfPresent(GeoLocation.self, forKey: .geo) ?? GeoLocation()
        self.beacon = try container.decodeIfPresent(BeaconLocation.self, forKey: .beacon) ?? BeaconLocation()
    }
}

public class BeaconLocation : Codable {
    public var uniqueId : String = ""
    public var minor : String = ""
    public var major : String = ""
    
    public init() {
        
    }
    
    public init(uniqueId:String, minor:String, major:String) { //, geo:GeoLocation) {
        self.uniqueId = uniqueId
        self.minor = minor
        self.major = major
        //self.geo = geo
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uniqueId = try container.decodeIfPresent(String.self, forKey: .uniqueId) ?? ""
        self.minor = try container.decodeIfPresent(String.self, forKey: .minor) ?? ""
        self.major = try container.decodeIfPresent(String.self, forKey: .major) ?? ""
    }
}
