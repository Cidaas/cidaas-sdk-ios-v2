//
//  AccessTokenEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AccessTokenEntity : Codable {
    
    // properties
    public var sub: String = ""
    public var token_type: String = ""
    public var expires_in: Int64 = 0
    public var id_token_expires_in: Int64 = 0
    public var access_token: String = ""
    public var id_token: String = ""
    public var refresh_token: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.token_type = try container.decodeIfPresent(String.self, forKey: .token_type) ?? ""
        self.expires_in = try container.decodeIfPresent(Int64.self, forKey: .expires_in) ?? 0
        self.id_token_expires_in = try container.decodeIfPresent(Int64.self, forKey: .id_token_expires_in) ?? 0
        self.access_token = try container.decodeIfPresent(String.self, forKey: .access_token) ?? ""
        self.id_token = try container.decodeIfPresent(String.self, forKey: .id_token) ?? ""
        self.refresh_token = try container.decodeIfPresent(String.self, forKey: .refresh_token) ?? ""
    }
}
