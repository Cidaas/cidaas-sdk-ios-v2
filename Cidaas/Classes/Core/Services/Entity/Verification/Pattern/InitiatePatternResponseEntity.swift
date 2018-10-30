//
//  InitiatePatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class InitiatePatternResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: InitiatePatternResponseDataEntity = InitiatePatternResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(InitiatePatternResponseDataEntity.self, forKey: .data) ?? InitiatePatternResponseDataEntity()
    }
}

public class InitiatePatternResponseDataEntity : Codable {
    // properties
    public var statusId: String = ""
    public var current_status: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
    }
}
