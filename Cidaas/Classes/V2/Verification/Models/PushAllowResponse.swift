//
//  PushAllowResponse.swift
//  Cidaas
//
//  Created by ganesh on 10/05/19.
//

import Foundation

public class PushAllowResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: PushAllowResponseData = PushAllowResponseData()
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(PushAllowResponseData.self, forKey: .data) ?? PushAllowResponseData()
    }
}

public class PushAllowResponseData : Codable {
    public var sub : String = ""
    public var status_id: String = ""
    public var exchange_id : ExchangeIdResponse = ExchangeIdResponse()
    public var push_id: String = ""
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_random_numbers: [String] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.status_id = try container.decodeIfPresent(String.self, forKey: .status_id) ?? ""
        self.exchange_id = try container.decodeIfPresent(ExchangeIdResponse.self, forKey: .exchange_id) ?? ExchangeIdResponse()
        self.push_id = try container.decodeIfPresent(String.self, forKey: .push_id) ?? ""
        self.device_id = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        self.client_id = try container.decodeIfPresent(String.self, forKey: .client_id) ?? ""
        self.push_random_numbers = try container.decodeIfPresent([String].self, forKey: .push_random_numbers) ?? []
    }
}
