//
//  EnrollPatternEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class EnrollVoiceEntity : Codable {
    // properties
    public var statusId: String = ""
    public var verifierPassword: String = ""
    public var userDeviceId: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
