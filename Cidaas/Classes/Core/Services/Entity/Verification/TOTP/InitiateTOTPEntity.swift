//
//  InitiateTOTPEntity.swift
//  Cidaas
//
//  Created by ganesh on 17/07/18.
//

import Foundation

public class InitiateTOTPEntity : Codable {
    // properties
    public var usageType: String = ""
    public var email: String = ""
    public var mobile: String = ""
    public var sub: String = ""
    public var userDeviceId: String = ""
    public var client_id: String = ""
    public var usage_pass: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    public var source: String = "MOBILE"
    
    // Constructors
    public init() {
        
    }
}
