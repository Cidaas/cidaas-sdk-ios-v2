//
//  InitiateEmailEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class InitiateEmailEntity : Codable {
    // properties
    public var sub: String = ""
    public var email: String = ""
    public var mobile: String = ""
    public var usageType: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
