//
//  RegistrationResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class RegistrationResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: RegistrationResponseDataEntity = RegistrationResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(RegistrationResponseDataEntity.self, forKey: .data) ?? RegistrationResponseDataEntity()
    }
}

public class RegistrationResponseDataEntity : Codable {
    // properties
    public var sub: String = ""
    public var userStatus: String = ""
    public var email_verified: Bool = false
    public var suggested_action: String = ""
    public var trackId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.userStatus = try container.decodeIfPresent(String.self, forKey: .userStatus) ?? ""
        self.email_verified = try container.decodeIfPresent(Bool.self, forKey: .email_verified) ?? false
        self.suggested_action = try container.decodeIfPresent(String.self, forKey: .suggested_action) ?? ""
        self.trackId = try container.decodeIfPresent(String.self, forKey: .trackId) ?? ""
    }
}
