//
//  ClientInfoResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ClientInfoResponseEntity : Codable {
    
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: ClientInfoResponseDataEntity = ClientInfoResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(ClientInfoResponseDataEntity.self, forKey: .data) ?? ClientInfoResponseDataEntity()
    }
}

public class ClientInfoResponseDataEntity : Codable {
    
    // properties
    public var passwordless_enabled: Bool = false
    public var logo_uri: String = ""
    public var policy_uri: String = ""
    public var tos_uri: String = ""
    public var client_name: String = ""
    public var login_providers: [String] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.passwordless_enabled = try container.decodeIfPresent(Bool.self, forKey: .passwordless_enabled) ?? false
        self.logo_uri = try container.decodeIfPresent(String.self, forKey: .logo_uri) ?? ""
        self.policy_uri = try container.decodeIfPresent(String.self, forKey: .policy_uri) ?? ""
        self.tos_uri = try container.decodeIfPresent(String.self, forKey: .tos_uri) ?? ""
        self.client_name = try container.decodeIfPresent(String.self, forKey: .client_name) ?? ""
        self.login_providers = try container.decodeIfPresent([String].self, forKey: .login_providers) ?? []
    }
}
