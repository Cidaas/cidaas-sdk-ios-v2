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
    
    
    public var code: String = ""
    public var moreInfo: String = ""
    public var type: String = ""
    public var status: Int16 = 400
    public var referenceNumber: String = ""
    public var error: String = ""
    public var metadata: MetadataInfo = MetadataInfo()
    
    
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
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.moreInfo = try container.decodeIfPresent(String.self, forKey: .moreInfo) ?? ""
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.referenceNumber = try container.decodeIfPresent(String.self, forKey: .referenceNumber) ?? ""
        self.error = try container.decodeIfPresent(String.self, forKey: .error) ?? ""
        self.metadata = try container.decodeIfPresent(MetadataInfo.self, forKey: .metadata) ?? MetadataInfo()
    }
}

public class EnrollResponseMetaData : Codable {
    
    // properties
    public var comment: String = ""
    public var number_images_needed: Int32 = 0
    public var number_images_uploaded: Int32 = 0
    
    public var number_voices_needed: Int32 = 0
    public var number_voices_uploaded: Int32 = 0
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? ""
        self.number_images_needed = try container.decodeIfPresent(Int32.self, forKey: .number_images_needed) ?? 0
        self.number_images_uploaded = try container.decodeIfPresent(Int32.self, forKey: .number_images_uploaded) ?? 0
        self.number_voices_needed = try container.decodeIfPresent(Int32.self, forKey: .number_voices_needed) ?? 0
        self.number_voices_uploaded = try container.decodeIfPresent(Int32.self, forKey: .number_voices_uploaded) ?? 0
    }
}

public class MetadataInfo:Codable {
    
    public var meta: EnrollResponseMetaData = EnrollResponseMetaData()
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meta = try container.decodeIfPresent(EnrollResponseMetaData.self, forKey: .meta) ?? EnrollResponseMetaData()
    }
}
