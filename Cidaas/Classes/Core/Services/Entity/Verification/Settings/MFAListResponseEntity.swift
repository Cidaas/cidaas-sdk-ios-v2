//
//  MFAListResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class MFAListResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: [MFAListResponseDataEntity] = []
    public var metaData: NewSub = NewSub()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([MFAListResponseDataEntity].self, forKey: .data) ?? []
        self.metaData = try container.decodeIfPresent(NewSub.self, forKey: .metaData) ?? NewSub()
    }
}

public class MFAListResponseDataEntity : Codable {
    // properties
    public var _id: String = ""
    public var verificationType: String = ""
    public var verifierId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.verifierId = try container.decodeIfPresent(String.self, forKey: .verifierId) ?? ""
    }
}

public class NewSub : Codable {
    
    public var newSub : String = ""
    public var sub: String = ""
    public var identityId : String = ""
    public var name : String = ""
    public var given_name : String = ""
    public var family_name : String = ""
    public var provider : String = ""
    public var email : String = ""
    public var mobile : String = ""
    public var email_verified : Bool = false
    public var mobile_number_verified : Bool = false
    public var username : String = ""
    public var access_token: String = ""
    public var refresh_token: String = ""
    public var expires_in: Int64 = 86400
    
    public init() {
        
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.newSub = try container.decodeIfPresent(String.self, forKey: .newSub) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.identityId = try container.decodeIfPresent(String.self, forKey: .identityId) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.given_name = try container.decodeIfPresent(String.self, forKey: .given_name) ?? ""
        self.family_name = try container.decodeIfPresent(String.self, forKey: .family_name) ?? ""
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.email_verified = try container.decodeIfPresent(Bool.self, forKey: .email_verified) ?? false
        self.mobile_number_verified = try container.decodeIfPresent(Bool.self, forKey: .mobile_number_verified) ?? false
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.access_token = try container.decodeIfPresent(String.self, forKey: .access_token) ?? ""
        self.refresh_token = try container.decodeIfPresent(String.self, forKey: .refresh_token) ?? ""
        self.expires_in = try container.decodeIfPresent(Int64.self, forKey: .expires_in) ?? 86400
    }
}
