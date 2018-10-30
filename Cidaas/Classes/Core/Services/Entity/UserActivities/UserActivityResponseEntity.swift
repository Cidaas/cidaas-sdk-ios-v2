//
//  UserActivityResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class UserActivityResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: [UserActivityResponseDataEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([UserActivityResponseDataEntity].self, forKey: .data) ?? []
    }
}

public class UserActivityResponseDataEntity : Codable {
    // properties
    public var createdTime: String = ""
    public var deviceModel: String = ""
    public var deviceMake: String = ""
    public var browserName: String = ""
    public var osName: String = ""
    public var socialIdentity: UserActivityResponseDataSocialIdentityEntity = UserActivityResponseDataSocialIdentityEntity()
    public var userId: String = ""
    public var provider: String = ""
    public var factEventType: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
        self.deviceModel = try container.decodeIfPresent(String.self, forKey: .deviceModel) ?? ""
        self.deviceMake = try container.decodeIfPresent(String.self, forKey: .deviceMake) ?? ""
        self.browserName = try container.decodeIfPresent(String.self, forKey: .browserName) ?? ""
        self.osName = try container.decodeIfPresent(String.self, forKey: .osName) ?? ""
        self.socialIdentity = try container.decodeIfPresent(UserActivityResponseDataSocialIdentityEntity.self, forKey: .socialIdentity) ?? UserActivityResponseDataSocialIdentityEntity()
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.factEventType = try container.decodeIfPresent(String.self, forKey: .factEventType) ?? ""
    }
}

public class UserActivityResponseDataSocialIdentityEntity : Codable {
    // properties
    public var firstname: String = ""
    public var lastname: String = ""
    public var photoURL: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstname = try container.decodeIfPresent(String.self, forKey: .firstname) ?? ""
        self.lastname = try container.decodeIfPresent(String.self, forKey: .lastname) ?? ""
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL) ?? ""
       
    }
}
