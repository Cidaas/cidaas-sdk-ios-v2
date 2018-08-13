//
//  LinkAccountResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class LinkAccountResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: LinkAccountResponseDataEntity = LinkAccountResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(LinkAccountResponseDataEntity.self, forKey: .data) ?? LinkAccountResponseDataEntity()
    }
}

public class LinkAccountResponseDataEntity : Codable {
    // properties
    public var updated: Bool = false
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.updated = try container.decodeIfPresent(Bool.self, forKey: .updated) ?? false
    }
}
