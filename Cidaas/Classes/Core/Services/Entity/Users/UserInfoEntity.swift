//
//  UserInfoEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class UserInfoEntity: Codable {
    
    public var last_used_identity_id: String = ""
    public var _id: String = ""
    public var profile: String = ""
    public var mobile_number_verified: Bool = false
    public var mobile_number: String = ""
    public var given_name: String = ""
    public var family_name: String = ""
    public var email_verified: Bool = false
    public var email: String = ""
    public var provider: String = ""
    public var sub: String = ""
    public var roles: [String] = []
    public var groups: [UserInfoGroups] = []
    public var name: String = ""
    public var preferred_username: String = ""
    public var nickname: String = ""
    public var user_status: String = ""
    public var identities: [UserInfoIdentity] = []
    public var picture: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.last_used_identity_id = try container.decodeIfPresent(String.self, forKey: .last_used_identity_id) ?? ""
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.profile = try container.decodeIfPresent(String.self, forKey: .profile) ?? ""
        self.mobile_number_verified = try container.decodeIfPresent(Bool.self, forKey: .mobile_number_verified) ?? false
        self.mobile_number = try container.decodeIfPresent(String.self, forKey: .mobile_number) ?? ""
        self.given_name = try container.decodeIfPresent(String.self, forKey: .given_name) ?? ""
        self.family_name = try container.decodeIfPresent(String.self, forKey: .family_name) ?? ""
        self.email_verified = try container.decodeIfPresent(Bool.self, forKey: .email_verified) ?? false
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.roles = try container.decodeIfPresent([String].self, forKey: .roles) ?? []
        self.groups = try container.decodeIfPresent([UserInfoGroups].self, forKey: .groups) ?? []
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.preferred_username = try container.decodeIfPresent(String.self, forKey: .preferred_username) ?? ""
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
        self.user_status = try container.decodeIfPresent(String.self, forKey: .user_status) ?? ""
        self.identities = try container.decodeIfPresent([UserInfoIdentity].self, forKey: .identities) ?? []
        self.picture = try container.decodeIfPresent(String.self, forKey: .picture) ?? ""
    }
    
}

public class UserInfoIdentity: Codable {
    public var provider: String = ""
    public var identityId: String = ""
    public var email: String = ""
    public var email_verified: Bool = false
    public var mobile_number: String = ""
    public var mobile_number_verified: Bool = false
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.identityId = try container.decodeIfPresent(String.self, forKey: .identityId) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.email_verified = try container.decodeIfPresent(Bool.self, forKey: .email_verified) ?? false
        self.mobile_number = try container.decodeIfPresent(String.self, forKey: .mobile_number) ?? ""
        self.mobile_number_verified = try container.decodeIfPresent(Bool.self, forKey: .mobile_number_verified) ?? false
    }
}

public class UserInfoGroups: Codable {
    public var sub: String = ""
    public var groupId: String = ""
    public var path: String = ""
    public var roles: [String] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.groupId = try container.decodeIfPresent(String.self, forKey: .groupId) ?? ""
        self.path = try container.decodeIfPresent(String.self, forKey: .path) ?? ""
        self.roles = try container.decodeIfPresent([String].self, forKey: .roles) ?? []
    }
}
