//
//  ChangePasswordResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 01/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ChangePasswordResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: ChangePasswordResponseDataEntity = ChangePasswordResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(ChangePasswordResponseDataEntity.self, forKey: .data) ?? ChangePasswordResponseDataEntity()
    }
}

public class ChangePasswordResponseDataEntity : Codable {
    // properties
    public var changed: Bool = false
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.changed = try container.decodeIfPresent(Bool.self, forKey: .changed) ?? false
    }
}
