//
//  MFAListResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class MFAListResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: [MFAListResponseDataEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([MFAListResponseDataEntity].self, forKey: .data) ?? []
    }
}

public class MFAListResponseDataEntity : Codable {
    // properties
    public var _id: String = ""
    public var verificationType: String = ""
    public var devices: [MFAListResponseDeviceEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.devices = try container.decodeIfPresent([MFAListResponseDeviceEntity].self, forKey: .devices) ?? []
    }
}

public class MFAListResponseDeviceEntity : Codable {
    // properties
    public var _id: String = ""
    public var deviceType: String = ""
    public var deviceModel: String = ""
    public var deviceMake: String = ""
    public var deviceId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.deviceType = try container.decodeIfPresent(String.self, forKey: .deviceType) ?? ""
        self.deviceModel = try container.decodeIfPresent(String.self, forKey: .deviceModel) ?? ""
        self.deviceMake = try container.decodeIfPresent(String.self, forKey: .deviceMake) ?? ""
        self.deviceId = try container.decodeIfPresent(String.self, forKey: .deviceId) ?? ""
    }
}
