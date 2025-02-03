//
//  PendingNotificationResponse.swift
//  Cidaas
//
//  Created by ganesh on 23/05/19.
//

import Foundation

public class PendingNotificationResponse: Codable {
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: [PendingNotificationResponseData] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent([PendingNotificationResponseData].self, forKey: .data) ?? []
    }
}

public class PendingNotificationResponseData: Codable {
    public var sub : String = ""
    public var tenant_name: String = ""
    public var tenant_key: String = ""
    public var verification_type: String = ""
    public var request_time: String = ""
    public var requested_types: [String] = []
    public var exchange_id : String = ""
    public var expires_at : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.tenant_name = try container.decodeIfPresent(String.self, forKey: .tenant_name) ?? ""
        self.tenant_key = try container.decodeIfPresent(String.self, forKey: .tenant_key) ?? ""
        self.verification_type = try container.decodeIfPresent(String.self, forKey: .verification_type) ?? ""
        self.request_time = try container.decodeIfPresent(String.self, forKey: .request_time) ?? ""
        self.requested_types = try container.decodeIfPresent([String].self, forKey: .requested_types) ?? []
        self.exchange_id = try container.decodeIfPresent(String.self, forKey: .exchange_id) ?? ""
        self.expires_at = try container.decodeIfPresent(String.self, forKey: .expires_at) ?? ""
    }
}
