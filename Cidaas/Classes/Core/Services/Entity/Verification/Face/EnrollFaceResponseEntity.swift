//
//  EnrollPatternResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 23/07/18.
//

import Foundation

public class EnrollFaceResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: EnrollFaceResponseDataEntity = EnrollFaceResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(EnrollFaceResponseDataEntity.self, forKey: .data) ?? EnrollFaceResponseDataEntity()
    }
}

public class EnrollFaceResponseDataEntity : Codable {
    // properties
    public var current_status: String = ""
    public var sub: String = ""
    public var trackingCode: String = ""
    public var verificationType: String = ""
    public var usageType: String = ""
    public var enrolled: Bool?
    public var meta: EnrollFaceResponseMetaData?
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.current_status = try container.decodeIfPresent(String.self, forKey: .current_status) ?? ""
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.trackingCode = try container.decodeIfPresent(String.self, forKey: .trackingCode) ?? ""
        self.verificationType = try container.decodeIfPresent(String.self, forKey: .verificationType) ?? ""
        self.usageType = try container.decodeIfPresent(String.self, forKey: .usageType) ?? ""
        self.enrolled = try container.decodeIfPresent(Bool.self, forKey: .enrolled)
        self.meta = try container.decodeIfPresent(EnrollFaceResponseMetaData.self, forKey: .meta)
    }
}

public class EnrollFaceResponseMetaData : Codable {
    
    // properties
    public var comment: String?
    public var number_images_needed: Int32?
    public var number_images_uploaded: Int32?
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)
        self.number_images_needed = try container.decodeIfPresent(Int32.self, forKey: .number_images_needed)
        self.number_images_uploaded = try container.decodeIfPresent(Int32.self, forKey: .number_images_uploaded)
    }
}
