//
//  ConsentDetailsV2ResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 03/04/19.
//

import Foundation

public class ConsentDetailsV2ResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: IConsentResponseData = IConsentResponseData()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(IConsentResponseData.self, forKey: .data) ?? IConsentResponseData()
    }
}

public class IConsentResponseData : Codable {
    // properties
    public var consent_id: String = ""
    public var consent_name: String = ""
    public var consent_version_id: String = ""
    public var content: String = ""
    public var scopes: [IConsentResponseScopes] = []
    public var sub: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.consent_id = try container.decodeIfPresent(String.self, forKey: .consent_id) ?? ""
        self.consent_name = try container.decodeIfPresent(String.self, forKey: .consent_name) ?? ""
        self.consent_version_id = try container.decodeIfPresent(String.self, forKey: .consent_version_id) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.scopes = try container.decodeIfPresent([IConsentResponseScopes].self, forKey: .scopes) ?? []
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
    }
}

public class IConsentResponseScopes : Codable {
    // properties
    public var description: String = ""
    public var language: String = ""
    public var locale: String = ""
    public var scopeKey: String = ""
    
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.locale = try container.decodeIfPresent(String.self, forKey: .locale) ?? ""
        self.scopeKey = try container.decodeIfPresent(String.self, forKey: .scopeKey) ?? ""
    }
}
