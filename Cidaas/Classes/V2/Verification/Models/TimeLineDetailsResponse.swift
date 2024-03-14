//
//  TimeLineDetailsResponse.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation

public class TimeLineDetailsResponse: Codable {
    
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

    // constructor
    public init() {
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
    }
}

public class ExchangeIdConfig: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var exchange_id: String = ""
    public var expires_at: String = ""

    // constructor
    public init() {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.expires_at = try container.decodeIfPresent(String.self, forKey: .expires_at) ?? ""
    }

}

public class LocationDetailsTracking: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var distance_meter: Int = ""
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
