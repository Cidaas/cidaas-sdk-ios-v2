//
//  HandleResetPasswordResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class HandleResetPasswordResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: HandleResetPasswordResponseDataEntity = HandleResetPasswordResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(HandleResetPasswordResponseDataEntity.self, forKey: .data) ?? HandleResetPasswordResponseDataEntity()
    }
}

public class HandleResetPasswordResponseDataEntity : Codable {
    // properties
    public var exchangeId: String = ""
    public var resetRequestId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exchangeId = try container.decodeIfPresent(String.self, forKey: .exchangeId) ?? ""
        self.resetRequestId = try container.decodeIfPresent(String.self, forKey: .resetRequestId) ?? ""
    }
}
