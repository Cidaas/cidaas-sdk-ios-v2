//
//  InitiatePatternEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class InitiatePatternEntity : Codable {
    // properties
    public var usageType: String = ""
    public var email: String = ""
    public var mobile: String = ""
    public var sub: String = ""
    public var userDeviceId: String = ""
    public var client_id: String = ""
    public var usage_pass: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
