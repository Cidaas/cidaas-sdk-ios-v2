//
//  AuthenticatedHistoryResponse.swift
//  Cidaas
//
//  Created by ganesh on 23/05/19.
//

import Foundation

public class AuthenticatedHistoryResponse: Codable {
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: [AuthenticatedHistoryResponseData] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent([AuthenticatedHistoryResponseData].self, forKey: .data) ?? []
    }
}

public class AuthenticatedHistoryResponseData: Codable {
    public var sub : String = ""
    public var status_id: String = ""
    public var device_info: PushDeviceInfo = PushDeviceInfo()
    public var address: PushAddress = PushAddress()
    public var auth_time: Date = Date()
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.status_id = try container.decodeIfPresent(String.self, forKey: .status_id) ?? ""
        self.device_info = try container.decodeIfPresent(PushDeviceInfo.self, forKey: .device_info) ?? PushDeviceInfo()
        self.address = try container.decodeIfPresent(PushAddress.self, forKey: .address) ?? PushAddress()
        self.auth_time = try container.decodeIfPresent(Date.self, forKey: .auth_time) ?? Date()
    }
}
