//
//  PushAllowRequest.swift
//  Cidaas
//
//  Created by ganesh on 10/05/19.
//

import Foundation

public class PushAllowRequest: Codable {
    
    public init() {}
    
    public var exchange_id: String = ""
    public var push_id: String = ""
    public var device_id: String = ""
    public var client_id: String = ""
}
