//
//  MFAListResponse.swift
//  Cidaas
//
//  Created by ganesh on 21/05/19.
//

import Foundation

public class MFAListResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: [MFAListResponseData] = []
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent([MFAListResponseData].self, forKey: .data) ?? []
    }
}

public class MFAListResponseData : Codable {
    public var _id : String = ""
    public var configured_at: String = ""
    public var verification_type : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.configured_at = try container.decodeIfPresent(String.self, forKey: .configured_at) ?? ""
        self.verification_type = try container.decodeIfPresent(String.self, forKey: .verification_type) ?? ""
    }
}

