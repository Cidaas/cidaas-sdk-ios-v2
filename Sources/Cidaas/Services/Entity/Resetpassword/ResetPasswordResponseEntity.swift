//
//  ResetPasswordResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ResetPasswordResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: ResetPasswordResponseDataEntity = ResetPasswordResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(ResetPasswordResponseDataEntity.self, forKey: .data) ?? ResetPasswordResponseDataEntity()
    }
}

public class ResetPasswordResponseDataEntity : Codable {
    // properties
    public var reseted: Bool = false
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reseted = try container.decodeIfPresent(Bool.self, forKey: .reseted) ?? false
    }
}
