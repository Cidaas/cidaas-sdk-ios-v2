//
//  ScannedPatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class ScannedFaceResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: ScannedFaceResponseDataEntity = ScannedFaceResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(ScannedFaceResponseDataEntity.self, forKey: .data) ?? ScannedFaceResponseDataEntity()
    }
}

public class ScannedFaceResponseDataEntity : Codable {
    // properties
    public var userDeviceId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userDeviceId = try container.decodeIfPresent(String.self, forKey: .userDeviceId) ?? ""
    }
}
