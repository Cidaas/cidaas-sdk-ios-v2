//
//  InitiateAccountVerificationResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class InitiateAccountVerificationResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: InitiateAccountVerificationResponseDataEntity = InitiateAccountVerificationResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(InitiateAccountVerificationResponseDataEntity.self, forKey: .data) ?? InitiateAccountVerificationResponseDataEntity()
    }
}

public class InitiateAccountVerificationResponseDataEntity : Codable {
    // properties
    public var accvid: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accvid = try container.decodeIfPresent(String.self, forKey: .accvid) ?? ""
    }
}
