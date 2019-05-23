//
//  MFAListResponse.swift
//  Cidaas
//
//  Created by ganesh on 21/05/19.
//

import Foundation

public class MFAListResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: [MFAListResponseData] = []
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent([MFAListResponseData].self, forKey: .data) ?? []
    }
}

public class MFAListResponseData : Codable {
    
    public var user_info: UserInformation = UserInformation()
    public var tenant_name: String = ""
    public var tenant_key: String = ""
    public var configured_list: [MFAConfiguredList] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_info = try container.decodeIfPresent(UserInformation.self, forKey: .user_info) ?? UserInformation()
        self.tenant_name = try container.decodeIfPresent(String.self, forKey: .tenant_name) ?? ""
        self.tenant_key = try container.decodeIfPresent(String.self, forKey: .tenant_key) ?? ""
        self.configured_list = try container.decodeIfPresent([MFAConfiguredList].self, forKey: .configured_list) ?? []
    }
}

public class MFAConfiguredList: Codable {
    
    public var configured_at: String = ""
    public var verification_type : String = ""
    public var sub: String = ""
    public var totp_secret: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.configured_at = try container.decodeIfPresent(String.self, forKey: .configured_at) ?? ""
        self.verification_type = try container.decodeIfPresent(String.self, forKey: .verification_type) ?? ""
    }
}

