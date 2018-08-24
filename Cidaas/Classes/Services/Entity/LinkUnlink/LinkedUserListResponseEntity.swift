//
//  LinkedUserListResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class LinkedUserListResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: LinkedUserListResponseDataEntity = LinkedUserListResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(LinkedUserListResponseDataEntity.self, forKey: .data) ?? LinkedUserListResponseDataEntity()
    }
}

public class LinkedUserListResponseDataEntity : Codable {
    // properties
    public var identities: [LinkedUserListResponseDataIdentitiesEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identities = try container.decodeIfPresent([LinkedUserListResponseDataIdentitiesEntity].self, forKey: .identities) ?? []
    }
}

public class LinkedUserListResponseDataIdentitiesEntity : Codable {
    // properties
    public var email: String = ""
    public var provider: String = ""
    public var sub: String = ""
    public var _id: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
}
