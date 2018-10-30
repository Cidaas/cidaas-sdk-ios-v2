//
//  AuthenticatePatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class AuthenticateTouchResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: AuthenticateTouchResponseDataEntity = AuthenticateTouchResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(AuthenticateTouchResponseDataEntity.self, forKey: .data) ?? AuthenticateTouchResponseDataEntity()
    }
}

public class AuthenticateTouchResponseDataEntity : Codable {
    // properties
    public var sub: String = ""
    public var trackingCode: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.trackingCode = try container.decodeIfPresent(String.self, forKey: .trackingCode) ?? ""
    }
}
