//
//  RequestIdResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class RequestIdResponseEntity : Codable {
    
    // properties
    public var success: Bool = false
    public var status: Int16 = 0
    public var data: RequestIdResponseDataEntity = RequestIdResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(RequestIdResponseDataEntity.self, forKey: .data) ?? RequestIdResponseDataEntity()
    }
}

public class RequestIdResponseDataEntity : Codable {
    
    // properties
    public var groupname: String = ""
    public var lang: String = ""
    public var view_type: String = ""
    public var requestId: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupname = try container.decodeIfPresent(String.self, forKey: .groupname) ?? ""
        self.lang = try container.decodeIfPresent(String.self, forKey: .lang) ?? ""
        self.view_type = try container.decodeIfPresent(String.self, forKey: .view_type) ?? ""
        self.requestId = try container.decodeIfPresent(String.self, forKey: .requestId) ?? ""
    }
}
