//
//  SetupRequest.swift
//  Cidaas
//
//  Created by ganesh on 01/07/19.
//

import Foundation

public class SetupRequest: Codable {
    
    public init() {}
    
    public var access_token: String = ""
    public var sub: String = ""
    public var device_id: String = ""
    public var push_id: String = ""
}
