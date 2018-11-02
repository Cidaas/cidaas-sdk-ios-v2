//
//  SocialProviderEntity.swift
//  Cidaas
//
//  Created by ganesh on 02/11/18.
//

import Foundation

public class SocialProviderEntity : Codable {
    public var code : String = ""
    public var accessToken : String = ""
    public var redirectUrl : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
        self.redirectUrl = try container.decodeIfPresent(String.self, forKey: .redirectUrl) ?? ""
    }
}
