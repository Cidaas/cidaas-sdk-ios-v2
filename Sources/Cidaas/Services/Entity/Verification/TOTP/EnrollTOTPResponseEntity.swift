//
//  EnrollTOTPResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class EnrollTOTPResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: EnrollTOTPResponseDataEntity = EnrollTOTPResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(EnrollTOTPResponseDataEntity.self, forKey: .data) ?? EnrollTOTPResponseDataEntity()
    }
}

public class EnrollTOTPResponseDataEntity : Codable {
    // properties
    public var sub: String = ""
    public var trackingCode: String = ""
    public var verificationType: String = ""
    public var usageType: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.trackingCode = try container.decodeIfPresent(String.self, forKey: .trackingCode) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.usageType = try container.decodeIfPresent(String.self, forKey: .usageType) ?? ""
    }
}
