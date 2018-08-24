//
//  VerificationErrorResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class VerificationErrorResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var error: VerificationErrorResponseDataEntity = VerificationErrorResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.error = try container.decodeIfPresent(VerificationErrorResponseDataEntity.self, forKey: .error) ?? VerificationErrorResponseDataEntity()
    }
}

public class VerificationErrorResponseDataEntity : Codable {
    // properties
    public var code: Int32 = 0
    public var moreInfo: String = ""
    public var type: String = ""
    public var status: Int16 = 400
    public var referenceNumber: String = ""
    public var error: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(Int32.self, forKey: .code) ?? 0
        self.moreInfo = try container.decodeIfPresent(String.self, forKey: .moreInfo) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.referenceNumber = try container.decodeIfPresent(String.self, forKey: .referenceNumber) ?? ""
        self.error = try container.decodeIfPresent(String.self, forKey: .error) ?? ""
    }
}
