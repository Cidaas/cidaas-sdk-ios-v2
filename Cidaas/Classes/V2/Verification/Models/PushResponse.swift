//
//  PushResponse.swift
//  Cidaas
//
//  Created by ganesh on 08/05/19.
//

import Foundation

public class PushResponse : Codable {
    public var sub : String = ""
    public var tenant_name: String = ""
    public var exchange_id : ExchangeIdResponse = ExchangeIdResponse()
    public var tenant_key : String = ""
    public var requestTime: Int64 = 0
    public var verification_type : String = ""
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sub = try container.decodeIfPresent(String.self, forKey: .sub) ?? ""
        self.tenant_name = try container.decodeIfPresent(String.self, forKey: .tenant_name) ?? ""
        self.exchange_id = try container.decodeIfPresent(ExchangeIdResponse.self, forKey: .exchange_id) ?? ExchangeIdResponse()
        self.tenant_key = try container.decodeIfPresent(String.self, forKey: .tenant_key) ?? ""
        self.requestTime = try container.decodeIfPresent(Int64.self, forKey: .requestTime) ?? 0
        self.verification_type = try container.decodeIfPresent(String.self, forKey: .verification_type) ?? ""
    }
}
