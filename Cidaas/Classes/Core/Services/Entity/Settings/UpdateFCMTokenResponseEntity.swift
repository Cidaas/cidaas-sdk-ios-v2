//
//  UpdateFCMTokenResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 30/11/18.
//

import Foundation

public class UpdateFCMTokenResponseEntity : Codable {
    
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
    }
}
