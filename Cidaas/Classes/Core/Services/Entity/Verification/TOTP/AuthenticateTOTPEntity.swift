//
//  AuthenticateTOTPEntity.swift
//  Cidaas
//
//  Created by ganesh on 17/07/18.
//

import Foundation

public class AuthenticateTOTPEntity : Codable {
    // properties
    public var statusId: String = ""
    public var verifierPassword: String = ""
    public var userDeviceId: String = ""
    public var usage_pass: String = ""
    public var client_id: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
