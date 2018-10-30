//
//  AuthenticateBackupcodeResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AuthenticateBackupcodeResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AuthenticateBackupcodeResponseDataEntity = AuthenticateBackupcodeResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AuthenticateBackupcodeResponseDataEntity.self, forKey: .data) ?? AuthenticateBackupcodeResponseDataEntity()
    }
}

public class AuthenticateBackupcodeResponseDataEntity : Codable {
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
