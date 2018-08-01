//
//  SetupPatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation


public class SetupVoiceResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: SetupVoiceResponseDataEntity = SetupVoiceResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(SetupVoiceResponseDataEntity.self, forKey: .data) ?? SetupVoiceResponseDataEntity()
    }
}

public class SetupVoiceResponseDataEntity : Codable {
    // properties
    public var qrCode: String = ""
    public var queryString: String = ""
    public var statusId: String = ""
    public var verifierId: String = ""
    public var randomNumber: String = ""
    public var current_status: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.qrCode = try container.decodeIfPresent(String.self, forKey: .qrCode) ?? ""
        self.queryString = try container.decodeIfPresent(String.self, forKey: .queryString) ?? ""
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.verifierId = try container.decodeIfPresent(String.self, forKey: .verifierId) ?? ""
        self.randomNumber = try container.decodeIfPresent(String.self, forKey: .randomNumber) ?? ""
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
    }
}
