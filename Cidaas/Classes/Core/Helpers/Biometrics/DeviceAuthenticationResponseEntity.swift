//
//  DeviceAuthenticationResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 18/02/19.
//

import Foundation

public class DeviceAuthenticationResponseEntity: Codable {
    // properties
    public var success: Bool = false
    public var status: Int32 = 400
    public var message: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 400
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
