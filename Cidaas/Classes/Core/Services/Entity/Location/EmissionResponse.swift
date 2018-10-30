//
//  EmissionResponse.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation

public class EmissionResponse : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: EmissionResponseData = EmissionResponseData()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(EmissionResponseData.self, forKey: .data) ?? EmissionResponseData()
    }
}

public class EmissionResponseData: Codable {
    // properties
    public var result: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try container.decodeIfPresent(String.self, forKey: .result) ?? ""
    }
}
