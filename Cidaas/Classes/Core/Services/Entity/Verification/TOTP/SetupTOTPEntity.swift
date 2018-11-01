//
//  SetupTOTPEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class SetupTOTPEntity : Codable {
    // properties
    public var client_id: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    public var logoUrl: String = ""
    
    // Constructors
    public init() {
        
    }
}
