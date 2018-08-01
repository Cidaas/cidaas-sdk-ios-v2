//
//  SetupEmailResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class SetupSMSResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: SetupSMSResponseDataEntity = SetupSMSResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(SetupSMSResponseDataEntity.self, forKey: .data) ?? SetupSMSResponseDataEntity()
    }
}

public class SetupSMSResponseDataEntity : Codable {
    // properties
    public var statusId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
    }
}
