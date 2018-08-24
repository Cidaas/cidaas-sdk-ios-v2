//
//  InitiateResetPasswordResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class InitiateResetPasswordResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: InitiateResetPasswordResponseDataEntity = InitiateResetPasswordResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(InitiateResetPasswordResponseDataEntity.self, forKey: .data) ?? InitiateResetPasswordResponseDataEntity()
    }
}

public class InitiateResetPasswordResponseDataEntity : Codable {
    // properties
    public var reset_initiated: Bool = false
    public var rprq: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reset_initiated = try container.decodeIfPresent(Bool.self, forKey: .reset_initiated) ?? false
        self.rprq = try container.decodeIfPresent(String.self, forKey: .rprq) ?? ""
    }
}
