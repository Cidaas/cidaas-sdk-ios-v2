//
//  DeduplicationDetailsResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 31/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class DeduplicationDetailsResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: DeduplicationDetailsResponseDataEntity = DeduplicationDetailsResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(DeduplicationDetailsResponseDataEntity.self, forKey: .data) ?? DeduplicationDetailsResponseDataEntity()
    }
}

public class DeduplicationDetailsResponseDataEntity : Codable {
    // properties
    public var email: String = ""
    public var deduplicationList: [DuplicationList] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.deduplicationList = try container.decodeIfPresent([DuplicationList].self, forKey: .deduplicationList) ?? []
    }
}

public class DuplicationList : Codable {
    // properties
    public var email: String = ""
    public var provider: String = ""
    public var sub: String = ""
    public var emailName: String = ""
    public var firstname: String = ""
    public var lastname: String = ""
    public var displayName: String = ""
    public var currentLocale: String = ""
    public var country: String = ""
    public var region: String = ""
    public var city: String = ""
    public var zipcode: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.emailName = try container.decodeIfPresent(String.self, forKey: .emailName) ?? ""
        self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname) ?? ""
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? ""
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        self.currentLocale = try container.decodeIfPresent(String.self, forKey: .currentLocale) ?? ""
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.zipcode = try container.decodeIfPresent(String.self, forKey: .zipcode) ?? ""
    }
}
