//
//  InitiatePatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class InitiateFaceResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: InitiateFaceResponseDataEntity = InitiateFaceResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(InitiateFaceResponseDataEntity.self, forKey: .data) ?? InitiateFaceResponseDataEntity()
    }
}

public class InitiateFaceResponseDataEntity : Codable {
    // properties
    public var statusId: String = ""
    public var current_status: String = ""
    public var randomNumber: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
        self.randomNumber = try container.decodeIfPresent(String.self, forKey: .randomNumber) ?? ""
    }
}
