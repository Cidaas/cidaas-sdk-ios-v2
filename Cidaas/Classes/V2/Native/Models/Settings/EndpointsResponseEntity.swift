//
//  EndpointsResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/11/18.
//

import Foundation

public class EndpointsResponseEntity : Codable {
    public var issuer: String = ""
    public var userinfo_endpoint: String = ""
    public var authorization_endpoint: String = ""
    public var introspection_endpoint: String = ""
    public var introspection_async_update_endpoint: String = ""
    public var revocation_endpoint: String = ""
    public var token_endpoint: String = ""
    public var jwks_uri: String = ""
    public var check_session_iframe: String = ""
    public var end_session_endpoint: String = ""
    public var social_provider_token_resolver_endpoint: String = ""
    public var device_authorization_endpoint: String = ""
    public var scim_endpoint: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.issuer = try container.decodeIfPresent(String.self, forKey: .issuer) ?? ""
        self.userinfo_endpoint = try container.decodeIfPresent(String.self, forKey: .userinfo_endpoint) ?? ""
        self.authorization_endpoint = try container.decodeIfPresent(String.self, forKey: .authorization_endpoint) ?? ""
        self.introspection_endpoint = try container.decodeIfPresent(String.self, forKey: .introspection_endpoint) ?? ""
        self.introspection_async_update_endpoint = try container.decodeIfPresent(String.self, forKey: .introspection_async_update_endpoint) ?? ""
        self.revocation_endpoint = try container.decodeIfPresent(String.self, forKey: .revocation_endpoint) ?? ""
        self.token_endpoint = try container.decodeIfPresent(String.self, forKey: .token_endpoint) ?? ""
        self.jwks_uri = try container.decodeIfPresent(String.self, forKey: .jwks_uri) ?? ""
        self.check_session_iframe = try container.decodeIfPresent(String.self, forKey: .check_session_iframe) ?? ""
        self.end_session_endpoint = try container.decodeIfPresent(String.self, forKey: .end_session_endpoint) ?? ""
        self.social_provider_token_resolver_endpoint = try container.decodeIfPresent(String.self, forKey: .social_provider_token_resolver_endpoint) ?? ""
        self.device_authorization_endpoint = try container.decodeIfPresent(String.self, forKey: .device_authorization_endpoint) ?? ""
        self.scim_endpoint = try container.decodeIfPresent(String.self, forKey: .scim_endpoint) ?? ""
    }
}
