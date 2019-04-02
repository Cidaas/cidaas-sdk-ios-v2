//
//  UserLoginInfoResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 12/03/19.
//

import Foundation

public class UserLoginInfoResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: [UserLoginInfoResponseDataEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([UserLoginInfoResponseDataEntity].self, forKey: .data) ?? []
    }
}

public class UserLoginInfoResponseDataEntity : Codable {
    // properties
    public var _id: String = ""
    public var currentState: String = ""
    public var sub: String = ""
    public var verificationType: String = ""
    public var time: String = ""
    public var deviceInfo: PushDeviceInfo = PushDeviceInfo()
    public var address: PushAddress = PushAddress()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.currentState = try container.decodeIfPresent(String.self, forKey: .currentState) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.time = try container.decodeIfPresent(String.self, forKey: .time) ?? ""
        self.deviceInfo = try container.decodeIfPresent(PushDeviceInfo.self, forKey: .deviceInfo) ?? PushDeviceInfo()
        self.address = try container.decodeIfPresent(PushAddress.self, forKey: .address) ?? PushAddress()
    }
}
