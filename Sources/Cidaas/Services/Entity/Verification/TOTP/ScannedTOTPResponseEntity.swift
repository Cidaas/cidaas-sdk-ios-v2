//
//  ScannedTOTPResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ScannedTOTPResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: ScannedTOTPResponseDataEntity = ScannedTOTPResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(ScannedTOTPResponseDataEntity.self, forKey: .data) ?? ScannedTOTPResponseDataEntity()
    }
}

public class ScannedTOTPResponseDataEntity : Codable {
    // properties
    public var userDeviceId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userDeviceId = try container.decodeIfPresent(String.self, forKey: .userDeviceId) ?? ""
    }
}
