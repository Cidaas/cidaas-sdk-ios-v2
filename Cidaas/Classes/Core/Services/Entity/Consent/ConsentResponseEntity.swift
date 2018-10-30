//
//  ConsentResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ConsentResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(String.self, forKey: .data) ?? ""
    }
}
