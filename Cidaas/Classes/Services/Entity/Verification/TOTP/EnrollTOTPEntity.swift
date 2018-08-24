//
//  EnrollTOTPEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class EnrollTOTPEntity : Codable {
    // properties
    public var statusId: String = ""
    public var verifierPassword: String = ""
    public var userDeviceId: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
