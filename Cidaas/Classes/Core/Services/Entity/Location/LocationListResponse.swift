//
//  LocationSearch.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation

public class LocationListResponse: Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: LocationListResponseData = LocationListResponseData()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(LocationListResponseData.self, forKey: .data) ?? LocationListResponseData()
    }
}

public class LocationListResponseData : Codable {
    // properties
    public var count: Int16 = 0
    public var data: [BranchLocation] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decodeIfPresent(Int16.self, forKey: .count) ?? 0
        self.data = try container.decodeIfPresent([BranchLocation].self, forKey: .data) ?? []
    }
}

public class BranchLocation : Codable {
    // properties
    public var locationId: String = ""
    public var coordinates: [Float] = []
    public var radius: Int16 = 10
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locationId = try container.decodeIfPresent(String.self, forKey: .locationId) ?? ""
        self.coordinates = try container.decodeIfPresent([Float].self, forKey: .coordinates) ?? []
        self.radius = try container.decodeIfPresent(Int16.self, forKey: .radius) ?? 10
    }
}
