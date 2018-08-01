//
//  AcceptConsentResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AcceptConsentResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AcceptConsentDataEntity = AcceptConsentDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AcceptConsentDataEntity.self, forKey: .data) ?? AcceptConsentDataEntity()
    }
}

public class AcceptConsentDataEntity : Codable {
    // properties
    public var name: String = ""
    public var client_id: String = ""
    public var sub: String = ""
    public var version: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.version = try container.decodeIfPresent(String.self, forKey: .version) ?? ""
    }
}
