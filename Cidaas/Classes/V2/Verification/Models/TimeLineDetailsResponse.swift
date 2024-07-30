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
        self.expires_at = try container.decodeIfPresent(String.self, forKey: .expires_at) ?? ""
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
        self.updatedTime = try container.decodeIfPresent(String.self, forKey: .updatedTime) ?? ""
    }

}

public class LocationDetailsTracking: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var distance_meter: Int = 0
    public var location_info = Location()
    public var ipaddress_info = IpAddress()

    // constructor
    public init() {
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

}
