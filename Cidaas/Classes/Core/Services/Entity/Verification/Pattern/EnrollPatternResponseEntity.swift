//
//  EnrollPatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class EnrollPatternResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: EnrollPatternResponseDataEntity = EnrollPatternResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(EnrollPatternResponseDataEntity.self, forKey: .data) ?? EnrollPatternResponseDataEntity()
    }
}

public class EnrollPatternResponseDataEntity : Codable {
    // properties
    public var sub: String = ""
    public var trackingCode: String = ""
    public var verificationType: String = ""
    public var usageType: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.trackingCode = try container.decodeIfPresent(String.self, forKey: .trackingCode) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.usageType = try container.decodeIfPresent(String.self, forKey: .usageType) ?? ""
    }
}
