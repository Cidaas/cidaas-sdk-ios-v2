//
//  EnrollResponse.swift
//  Cidaas
//
//  Created by ganesh on 07/05/19.
//

import Foundation

public class EnrollResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: EnrollResponseData = EnrollResponseData()
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(EnrollResponseData.self, forKey: .data) ?? EnrollResponseData()
    }
}

public class EnrollResponseData: Codable {
    
    public init() {}
    
    public var exchange_id: ExchangeIdResponse = ExchangeIdResponse()
    public var sub: String = ""
    public var status_id: String = ""
    
    public var enrolled: Bool?
    public var meta: EnrollResponseMetaData?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exchange_id = try container.decodeIfPresent(ExchangeIdResponse.self, forKey: .exchange_id) ?? ExchangeIdResponse()
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.status_id = try container.decodeIfPresent(String.self, forKey: .status_id) ?? ""
        self.enrolled = try container.decodeIfPresent(Bool.self, forKey: .enrolled) ?? false
        self.meta = try container.decodeIfPresent(EnrollResponseMetaData.self, forKey: .meta) ?? EnrollResponseMetaData()
    }
}

public class EnrollResponseMetaData : Codable {
    
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
