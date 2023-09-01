//
//  AccessTokenModel.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AccessTokenModel : Codable {
    
    // shared instance
    public static var shared : AccessTokenModel = AccessTokenModel()
    
    // properties
    public var access_token: String = ""
    public var userstate: String = ""
    public var refresh_token: String = ""
    public var scope: String = ""
    public var id_token: String = ""
    public var expires_in: Int64 = 0
    public var sub: String = ""
    public var seconds: Int64 = 0
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access_token = try container.decodeIfPresent(String.self, forKey: .access_token) ?? ""
        self.userstate = try container.decodeIfPresent(String.self, forKey: .userstate) ?? ""
        self.refresh_token = try container.decodeIfPresent(String.self, forKey: .refresh_token) ?? ""
        self.scope = try container.decodeIfPresent(String.self, forKey: .scope) ?? ""
        self.id_token = try container.decodeIfPresent(String.self, forKey: .id_token) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.seconds = try container.decodeIfPresent(Int64.self, forKey: .seconds) ?? 0
        self.expires_in = try container.decodeIfPresent(Int64.self, forKey: .expires_in) ?? 0
    }
}
