//
//  MFAHistoryResponse.swift
//  Cidaas
//
//  Created by ganesh on 23/05/19.
//

import Foundation

public class MFAHistoryResponse: Codable {
    public var success: Bool = false
    public var status: Int32 = 0
    public var data = OverallMFAHistoryResponse()
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(OverallMFAHistoryResponse.self, forKey: .data) ?? OverallMFAHistoryResponse()
    }
}
public class OverallMFAHistoryResponse: Codable {
    public var initiated: Int32 = 0
    public var authenticated: Int32 = 0
    public var failed: Int32 = 0
    public var data: [MFAHistoryResponseData] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.initiated = Int32(try container.decodeIfPresent(Int.self, forKey: .initiated) ?? 0)
        self.authenticated = Int32(try container.decodeIfPresent(Int.self, forKey: .authenticated) ?? 0)
        self.failed = Int32(try container.decodeIfPresent(Int.self, forKey: .failed) ?? 0)
        self.data = try container.decodeIfPresent([MFAHistoryResponseData].self, forKey: .data) ?? []
    }
}

public class MFAHistoryResponseData: Codable {
    public var _id: String = ""
    public var device_info: PushDeviceInformation = PushDeviceInformation()
    public var location_details: LocationDetails = LocationDetails()
    public var auth_time: String = ""
    public var initial_status: String = ""
    public var final_status: String = ""
    public var authenticated: Bool = false
    public var address: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.device_info = try container.decodeIfPresent(PushDeviceInformation.self, forKey: .device_info) ?? PushDeviceInformation()
        self.location_details = try container.decodeIfPresent(LocationDetails.self, forKey: .location_details) ?? LocationDetails()
        self.auth_time = try container.decodeIfPresent(String.self, forKey: .auth_time) ?? ""
        self.initial_status = try container.decodeIfPresent(String.self, forKey: .initial_status) ?? ""
        self.final_status = try container.decodeIfPresent(String.self, forKey: .final_status) ?? ""
        self.authenticated = try container.decodeIfPresent(Bool.self, forKey: .authenticated) ?? false
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
    }
}

public class LocationDetails: Codable {
    
    public var ipaddress_info: IPAddressDetails = IPAddressDetails()
    public var _id: String = ""
    public var createdTime: String = ""
    public var updatedTime: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ipaddress_info = try container.decodeIfPresent(IPAddressDetails.self, forKey: .ipaddress_info) ?? IPAddressDetails()
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
        self.updatedTime = try container.decodeIfPresent(String.self, forKey: .updatedTime) ?? ""
    }
}

public class IPAddressDetails: Codable {
    public var ipAddress: String = ""
    public var location: Location = Location()
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress) ?? ""
        self.location = try container.decodeIfPresent(Location.self, forKey: .location) ?? Location()
    }
}

public class Location: Codable {
    public var address: PushAddress = PushAddress()
    public var lat: String = ""
    public var lon: String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(PushAddress.self, forKey: .address) ?? PushAddress()
        self.lat = try container.decodeIfPresent(String.self, forKey: .lat) ?? ""
        self.lon = try container.decodeIfPresent(String.self, forKey: .lon) ?? ""
    }
}
