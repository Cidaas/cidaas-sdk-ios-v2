//
//  LocationEmission.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation

public class LocationEmission : Codable {
    public var deviceId : String = ""
    public var sessionId : String = ""
    public var status : String = ""
    public var sub : String = ""
    public var geo : GeoLocation = GeoLocation()
    public var locationIds : [String] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId) ?? ""
        self.sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId) ?? ""
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.geo = try container.decodeIfPresent(GeoLocation.self, forKey: .geo) ?? GeoLocation()
        self.locationIds = try container.decodeIfPresent([String].self, forKey: .locationIds) ?? []
    }
}

public class GeoLocation : Codable {
    public var coordinates : [String] = []
    
    public init() {
        
    }
    public init(latitude:Double, longitude:Double, coordinates: [String]) {
        self.coordinates = []
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coordinates = try container.decodeIfPresent([String].self, forKey: .coordinates) ?? []
    }
}
