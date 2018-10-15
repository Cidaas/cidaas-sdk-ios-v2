//
//  BeaconListResponse.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation

public class BeaconListResponse: Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: [BeaconListResponseData] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([BeaconListResponseData].self, forKey: .data) ?? []
    }
}

public class BeaconListResponseData : Codable {
    // properties
    public var vendor : String = ""
    public var uniqueId : [String] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.vendor = try container.decodeIfPresent(String.self, forKey: .vendor) ?? ""
        self.uniqueId = try container.decodeIfPresent([String].self, forKey: .uniqueId) ?? []
    }
}
