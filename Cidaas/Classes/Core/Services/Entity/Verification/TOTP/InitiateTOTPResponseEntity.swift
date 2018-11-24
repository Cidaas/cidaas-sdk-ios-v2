//
//  InitiateTOTPResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 17/07/18.
//

import Foundation

public class InitiateTOTPResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: InitiateTOTPResponseDataEntity = InitiateTOTPResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(InitiateTOTPResponseDataEntity.self, forKey: .data) ?? InitiateTOTPResponseDataEntity()
    }
}

public class InitiateTOTPResponseDataEntity : Codable {
    // properties
    public var statusId: String = ""
    public var current_status: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
    }
}
