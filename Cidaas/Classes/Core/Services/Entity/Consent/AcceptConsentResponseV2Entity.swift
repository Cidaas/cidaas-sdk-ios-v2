//
//  AcceptConsentResponseV2Entity.swift
//  Cidaas
//
//  Created by ganesh on 03/04/19.
//

import Foundation

public class AcceptConsentResponseV2Entity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AcceptConsentResponseDataV2Entity = AcceptConsentResponseDataV2Entity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AcceptConsentResponseDataV2Entity.self, forKey: .data) ?? AcceptConsentResponseDataV2Entity()
    }
}

public class AcceptConsentResponseDataV2Entity : Codable {
    
    public var accepted: Bool = false
    public var consent_id: String = ""
    public var consent_version_id: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accepted = try container.decodeIfPresent(Bool.self, forKey: .accepted) ?? false
        self.consent_id = try container.decodeIfPresent(String.self, forKey: .consent_id) ?? ""
        self.consent_version_id = try container.decodeIfPresent(String.self, forKey: .consent_version_id) ?? ""
    }
}
