//
//  AuthzCodeEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AuthzCodeEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AuthzCodeDataEntity = AuthzCodeDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AuthzCodeDataEntity.self, forKey: .data) ?? AuthzCodeDataEntity()
    }
}

public class AuthzCodeDataEntity : Codable {
    
    // properties
    public var code: String = ""
    public var viewtype: String = ""
    public var grant_type: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.viewtype = try container.decodeIfPresent(String.self, forKey: .viewtype) ?? ""
        self.grant_type = try container.decodeIfPresent(String.self, forKey: .grant_type) ?? ""
    }
}
