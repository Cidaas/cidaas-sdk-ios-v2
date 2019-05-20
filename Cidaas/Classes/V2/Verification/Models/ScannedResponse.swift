//
//  ScannedResponse.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class ScannedResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: ScannedResponseData = ScannedResponseData()
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(ScannedResponseData.self, forKey: .data) ?? ScannedResponseData()
    }
}

public class ScannedResponseData: Codable {
    
    public init() {}
    
    public var exchange_id: ExchangeIdResponse = ExchangeIdResponse()
    public var sub: String = ""
    public var status_id: String = ""
    public var push_random_numbers: [String] = []
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exchange_id = try container.decodeIfPresent(ExchangeIdResponse.self, forKey: .exchange_id) ?? ExchangeIdResponse()
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.status_id = try container.decodeIfPresent(String.self, forKey: .status_id) ?? ""
        self.push_random_numbers = try container.decodeIfPresent([String].self, forKey: .push_random_numbers) ?? []
    }
}

public class ExchangeIdResponse: Codable {
    
    public init() {}
    
    public var exchange_id: String = ""
    public var expires_at: String = ""
    public var _id: String = ""
    public var createdTime: String = ""
    public var updatedTime: String = ""
    public var __ref: String = ""
    public var id: String = ""
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exchange_id = try container.decodeIfPresent(String.self, forKey: .exchange_id) ?? ""
        self.expires_at = try container.decodeIfPresent(String.self, forKey: .expires_at) ?? ""
        self._id = try container.decodeIfPresent(String.self, forKey: ._id) ?? ""
        self.createdTime = try container.decodeIfPresent(String.self, forKey: .createdTime) ?? ""
        self.updatedTime = try container.decodeIfPresent(String.self, forKey: .updatedTime) ?? ""
        self.__ref = try container.decodeIfPresent(String.self, forKey: .__ref) ?? ""
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
    }
}
