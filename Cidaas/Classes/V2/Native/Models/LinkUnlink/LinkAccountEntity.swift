//
//  LinkAccountEntity.swift
//  Cidaas
//
//  Created by Ganesh on 18/05/20.
//

import Foundation

public class LinkAccountEntity : Codable {
    // properties
    public var master_sub: String = ""
    public var sub_to_link: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.master_sub = try container.decodeIfPresent(String.self, forKey: .master_sub) ?? ""
        self.sub_to_link = try container.decodeIfPresent(String.self, forKey: .sub_to_link) ?? ""
    }
}
