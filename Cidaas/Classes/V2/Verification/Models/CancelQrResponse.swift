//
//  CancelQrResponse.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation

public class CancelQrResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: CancelQrResponseData = CancelQrResponseData()
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(CancelQrResponseData.self, forKey: .data) ?? CancelQrResponseData()
    }
}

public class CancelQrResponseData: Codable {
    // properties
    public var sub: String = ""
    public var status_id: String = ""
    public var exchange_id: ExchangeIdConfig = ExchangeIdConfig()
    
    // constructor
    public init () {
    }
    
}
