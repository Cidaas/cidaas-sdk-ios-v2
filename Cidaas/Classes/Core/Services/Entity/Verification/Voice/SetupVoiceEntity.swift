//
//  SetupPatternEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class SetupVoiceEntity : Codable {
    // properties
    public var logoUrl: String = ""
    public var client_id: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
