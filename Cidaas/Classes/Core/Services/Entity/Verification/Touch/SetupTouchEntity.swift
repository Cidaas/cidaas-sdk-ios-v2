//
//  SetupPatternEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class SetupTouchEntity : Codable {
    // properties
    public var client_id: String = ""
    public var logoUrl: String = ""
    public var usage_pass: String = ""
    public var deviceInfo: DeviceInfoModel = DeviceInfoModel()
    
    // Constructors
    public init() {
        
    }
}
