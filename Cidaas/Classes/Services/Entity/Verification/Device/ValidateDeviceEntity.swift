//
//  ValidateDeviceEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ValidateDeviceEntity : Codable {
    // properties
    public var intermediate_verifiation_id : String = ""
    public var access_verifier: String = ""
    public var statusId: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
