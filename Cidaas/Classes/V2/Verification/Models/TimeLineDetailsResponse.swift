//
//  TimeLineDetailsResponse.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation

public class TimeLineDetailsResponse: Codable {
    
    
    // properties
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: [TimeLineDetailsResponseData] = []
    
    // constructor
    public init () {
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent([TimeLineDetailsResponseData].self, forKey: .data) ?? []
    }
    
}


public class TimeLineDetailsResponseData: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var ph_id: String = ""
    public var verification_type: String = ""
    public var status: String = ""
    public var sub: String = ""
    public var client_id: String = ""
    public var status_id: String = ""
    public var request_id: String = ""
    public var medium_id: String = ""
    public var usage_type: String = ""
    public var parent_stage_id: String = ""
    public var used_exchange_id: String = ""
    public var rejected_reason: String = ""
    public var single_factor_auth: Bool = false
    public var valid: Bool = false
    public var provider: String = ""
    public var username: String = ""
    public var username_type: String = ""
    public var exchange_id = ExchangeIdConfig()
    public var device_info = DeviceInfoModel()
    public var location_details = LocationDetailsTracking()
    
    public var createdTime: String = ""

    
    // constructor
    public init () {
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.ph_id = try container.decodeIfPresent(String.self, forKey: .ph_id) ?? ""
        self.verification_type = try container.decodeIfPresent(String.self, forKey: .verification_type) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.status_id = try container.decodeIfPresent(String.self, forKey: .status_id) ?? ""
        self.request_id = try container.decodeIfPresent(String.self, forKey: .request_id) ?? ""
        self.medium_id = try container.decodeIfPresent(String.self, forKey: .medium_id) ?? ""
        self.usage_type = try container.decodeIfPresent(String.self, forKey: .usage_type) ?? ""
        self.parent_stage_id = try container.decodeIfPresent(String.self, forKey: .parent_stage_id) ?? ""
        self.used_exchange_id = try container.decodeIfPresent(String.self, forKey: .used_exchange_id) ?? ""
        self.rejected_reason = try container.decodeIfPresent(String.self, forKey: .rejected_reason) ?? ""
        self.single_factor_auth = try container.decodeIfPresent(Bool.self, forKey: .single_factor_auth) ?? false
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.username_type = try container.decodeIfPresent(String.self, forKey: .username_type) ?? ""
        self.exchange_id = try container.decodeIfPresent(ExchangeIdConfig.self, forKey: .exchange_id) ?? ExchangeIdConfig()
        self.device_info = try container.decodeIfPresent(DeviceInfoModel.self, forKey: .device_info) ?? DeviceInfoModel()
        self.location_details = try container.decodeIfPresent(LocationDetailsTracking.self, forKey: .location_details) ?? LocationDetailsTracking()
    }
}

public class ExchangeIdConfig: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var exchange_id: String = ""
    public var expires_at: String = ""
    public var createdTime: String = ""
    public var updatedTime: String = ""
    public var __ref: String = ""
    
    // constructor
    public init () {
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.exchange_id = try container.decodeIfPresent(String.self, forKey: .exchange_id) ?? ""
        self.expires_at = try container.decodeIfPresent(String.self, forKey: .expires_at) ?? ""
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
        self.updatedTime = try container.decodeIfPresent(String.self, forKey: .updatedTime) ?? ""
    }

}

public class LocationDetailsTracking: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var distance_metter: Float64 = 0
    public var location_info = Location()
    public var ipaddress_info = IpAddress()

    // constructor
    public init() {
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.distance_metter = try container.decodeIfPresent(Float64.self, forKey: .distance_metter) ?? 0
        self.location_info = try container.decodeIfPresent(Location.self, forKey: .location_info) ?? Location()
        self.ipaddress_info = try container.decodeIfPresent(IpAddress.self, forKey: .ipaddress_info) ?? IpAddress()
    }

}

public class IpAddress: Codable {
    
    // properties
    public var ipAddress: String = ""
    public var type: String = ""
    public var location = Location()

    // constructor
    public init() {
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.location = try container.decodeIfPresent(Location.self, forKey: .location) ?? Location()
    }

}
