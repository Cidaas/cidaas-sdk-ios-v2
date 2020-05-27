//
//  TenantInfoEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class TenantInfoResponseEntity : Codable {
    
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: TenantInfoResponseDataEntity = TenantInfoResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(TenantInfoResponseDataEntity.self, forKey: .data) ?? TenantInfoResponseDataEntity()
    }
}

public class TenantInfoResponseDataEntity : Codable {
    
    // properties
    public var tenant_name: String = ""
    public var allowLoginWith: [String] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tenant_name = try container.decodeIfPresent(String.self, forKey: .tenant_name) ?? ""
        self.allowLoginWith = try container.decodeIfPresent([String].self, forKey: .allowLoginWith) ?? []
    }
}
