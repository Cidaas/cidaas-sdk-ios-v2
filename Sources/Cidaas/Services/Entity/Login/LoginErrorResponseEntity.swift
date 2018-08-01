//
//  LoginErrorResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class LoginErrorResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var error: LoginErrorResponseDataEntity = LoginErrorResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.error = try container.decodeIfPresent(LoginErrorResponseDataEntity.self, forKey: .error) ?? LoginErrorResponseDataEntity()
    }
}

public class LoginErrorResponseDataEntity : Codable {
    // properties
    public var track_id: String = ""
    public var sub: String = ""
    public var requestId: String = ""
    public var client_id: String = ""
    public var consent_version: Int16 = 0
    public var consent_name: String = ""
    public var suggested_url: String = ""
    public var error: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.track_id = try container.decodeIfPresent(String.self, forKey: .track_id) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.requestId = try container.decodeIfPresent(String.self, forKey: .requestId) ?? ""
        self.suggested_url = try container.decodeIfPresent(String.self, forKey: .suggested_url) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.consent_version = try container.decodeIfPresent(Int16.self, forKey: .consent_version) ?? 0
        self.consent_name = try container.decodeIfPresent(String.self, forKey: .consent_name) ?? ""
        self.error = try container.decodeIfPresent(String.self, forKey: .error) ?? ""
    }
}
