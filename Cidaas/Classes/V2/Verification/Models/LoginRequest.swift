//
//  LoginRequest.swift
//  Cidaas
//
//  Created by ganesh on 01/07/19.
//

import Foundation

public class LoginRequest: Codable {
    
    public init() {}
    
    public var sub: String = ""
    public var pass_code: String = ""
    public var localizedReason: String = ""
    public var usage_type: String = ""
    public var track_id: String = ""
    public var request_id: String = ""
    public var verificationType: String = ""
}
