//
//  DeviceInfoModel.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class DeviceInfoModel : Codable {
    public var deviceId : String = ""
    public var deviceMake : String = ""
    public var deviceModel : String = ""
    public var deviceVersion : String = ""
    public var pushNotificationId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId) ?? ""
        self.deviceMake = try container.decodeIfPresent(String.self, forKey: .deviceMake) ?? ""
        self.deviceModel = try container.decodeIfPresent(String.self, forKey: .deviceModel) ?? ""
        self.deviceVersion = try container.decodeIfPresent(String.self, forKey: .deviceVersion) ?? ""
        self.pushNotificationId = try container.decodeIfPresent(String.self, forKey: .pushNotificationId) ?? ""
    }
}
