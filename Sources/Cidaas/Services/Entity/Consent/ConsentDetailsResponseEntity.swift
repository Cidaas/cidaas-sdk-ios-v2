//
//  ConsentDetailsResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ConsentDetailsResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: ConsentDetailsResponseDataEntity = ConsentDetailsResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(ConsentDetailsResponseDataEntity.self, forKey: .data) ?? ConsentDetailsResponseDataEntity()
    }
}

public class ConsentDetailsResponseDataEntity : Codable {
    // properties
    public var _id: String = ""
    public var description: String = ""
    public var title: String = ""
    public var userAgreeText: String = ""
    public var url: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.userAgreeText = try container.decodeIfPresent(String.self, forKey: .userAgreeText) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
}
