//
//  MFAConfiguredDeviceListResponse.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation

public class MFAConfiguredDeviceListResponse: Codable {
    
    // properties
    public var _id: String = ""
    public var id: String = ""
    public var friendly_name: String = ""
    public var ph_id: String = ""
    public var verification_type: String = ""
    public var sub: String = ""
    public var push_id: String = ""
    public var device_id: String = ""
    public var finger_print: String = ""
    public var user_device_id: String = ""
    public var passcode: String = ""
    public var pkce_key: String = ""
    public var client_id: String = ""
    public var createdTime: String = ""

    // constructor
    public init() {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
    }
}