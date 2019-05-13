//
//  ErrorResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ErrorResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var error:ErrorResponseDataEntity = ErrorResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.error = try container.decodeIfPresent(ErrorResponseDataEntity.self, forKey: .error) ?? ErrorResponseDataEntity()
    }
}


public class ErrorResponseDataEntity : Codable {
    // properties
    public var track_id: String = ""
    public var sub: String = ""
    public var requestId: String = ""
    public var client_id: String = ""
    public var consent_name: String = ""
    public var consent_id: String = ""
    public var consent_version_id: String = ""
    public var suggested_url: String = ""
    
    
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
        self.track_id = try container.decodeIfPresent(String.self, forKey: .track_id) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.requestId = try container.decodeIfPresent(String.self, forKey: .requestId) ?? ""
        self.suggested_url = try container.decodeIfPresent(String.self, forKey: .suggested_url) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.consent_name = try container.decodeIfPresent(String.self, forKey: .consent_name) ?? ""
        self.consent_id = try container.decodeIfPresent(String.self, forKey: .consent_id) ?? ""
        self.consent_version_id = try container.decodeIfPresent(String.self, forKey: .consent_version_id) ?? ""
        self.code = try container.decodeIfPresent(Int32.self, forKey: .code) ?? 0
        self.moreInfo = try container.decodeIfPresent(String.self, forKey: .moreInfo) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.referenceNumber = try container.decodeIfPresent(String.self, forKey: .referenceNumber) ?? ""
        self.error = try container.decodeIfPresent(String.self, forKey: .error) ?? ""
    }
}
