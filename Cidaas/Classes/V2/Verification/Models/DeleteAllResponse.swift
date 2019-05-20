//
//  DeleteAllResponse.swift
//  Cidaas
//
//  Created by ganesh on 20/05/19.
//

import Foundation

public class DeleteAllResponse: Codable {
    
    public init() {}
    
    public var success: Bool = false
    public var status: Int32 = 0
    public var data: Bool = false
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int32.self, forKey: .status) ?? 0
        self.data = try container.decodeIfPresent(Bool.self, forKey: .data) ?? false
    }
}
