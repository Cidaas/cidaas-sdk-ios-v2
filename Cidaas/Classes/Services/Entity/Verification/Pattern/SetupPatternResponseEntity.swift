//
//  SetupPatternResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class SetupPatternResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: SetupPatternResponseDataEntity = SetupPatternResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(SetupPatternResponseDataEntity.self, forKey: .data) ?? SetupPatternResponseDataEntity()
    }
}

public class SetupPatternResponseDataEntity : Codable {
    // properties
    public var qrCode: String = ""
    public var queryString: String = ""
    public var statusId: String = ""
    public var verifierId: String = ""
    public var randomNumber: String = ""
    public var current_status: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.qrCode = try container.decodeIfPresent(String.self, forKey: .qrCode) ?? ""
        self.queryString = try container.decodeIfPresent(String.self, forKey: .queryString) ?? ""
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.verifierId = try container.decodeIfPresent(String.self, forKey: .verifierId) ?? ""
        self.randomNumber = try container.decodeIfPresent(String.self, forKey: .randomNumber) ?? ""
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
    }
}
