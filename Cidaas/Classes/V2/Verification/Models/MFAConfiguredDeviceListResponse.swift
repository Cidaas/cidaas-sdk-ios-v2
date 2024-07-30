//
//  MFAConfiguredDeviceListResponse.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation
public class MFAConfiguredDeviceListResponse: Codable {
    
    
    // properties
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: [MFAConfiguredDeviceListResponseData] = []
    
    // constructor
    public init () {
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent([MFAConfiguredDeviceListResponseData].self, forKey: .data) ?? []
    }
    
}

public class MFAConfiguredDeviceListResponseData: Codable {
    public var _id: String = ""
    public var device_id: String = ""
    public var user_device_id: String = ""
    public var client_id: String = ""
    public var device_make: String = ""
    public var device_model: String = ""
    public var device_type: String = ""
    public var sub: String = ""
    public var last_used_time: String = ""
    public var last_used_location: String = ""
    public var tenantId : String = ""
    public var tenantName : String = ""
    
    
    public init() {}
    
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.device_id = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        self.user_device_id = try container.decodeIfPresent(String.self, forKey: .user_device_id) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.device_make = try container.decodeIfPresent(String.self, forKey: .device_make) ?? ""
        self.device_model = try container.decodeIfPresent(String.self, forKey: .device_model) ?? ""
        self.device_type = try container.decodeIfPresent(String.self, forKey: .device_type) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.last_used_time = try container.decodeIfPresent(String.self, forKey: .last_used_time) ?? ""
        self.last_used_location = try container.decodeIfPresent(String.self, forKey: .last_used_location) ?? ""
        self.tenantId = try container.decodeIfPresent(String.self, forKey: .tenantId) ?? ""
        self.tenantName = try container.decodeIfPresent(String.self, forKey: .tenantName) ?? ""
    }
}