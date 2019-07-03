//
//  AuthzCodeResponse.swift
//  Cidaas
//
//  Created by ganesh on 03/07/19.
//

import Foundation

public class AuthzCodeResponse : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: AuthzCodeResponseData = AuthzCodeResponseData()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(AuthzCodeResponseData.self, forKey: .data) ?? AuthzCodeResponseData()
    }
}

public class AuthzCodeResponseData : Codable {
    
    // properties
    public var code: String = ""
    public var viewtype: String = ""
    public var grant_type: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.viewtype = try container.decodeIfPresent(String.self, forKey: .viewtype) ?? ""
        self.grant_type = try container.decodeIfPresent(String.self, forKey: .grant_type) ?? ""
    }
}
