//
//  AccountVerificationListResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 20/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AccountVerificationListResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AccountVerificationListResponseDataEntity = AccountVerificationListResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AccountVerificationListResponseDataEntity.self, forKey: .data) ?? AccountVerificationListResponseDataEntity()
    }
}

public class AccountVerificationListResponseDataEntity: Codable {
    // properties
    public var EMAIL: Bool = false
    public var MOBILE: Bool = false
    public var USER_NAME: Bool = false
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.EMAIL = try container.decodeIfPresent(Bool.self, forKey: .EMAIL) ?? false
        self.MOBILE = try container.decodeIfPresent(Bool.self, forKey: .MOBILE) ?? false
        self.USER_NAME = try container.decodeIfPresent(Bool.self, forKey: .USER_NAME) ?? false
    }
}
