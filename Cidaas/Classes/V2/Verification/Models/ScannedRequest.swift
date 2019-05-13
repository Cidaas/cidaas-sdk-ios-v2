//
//  ScannedRequest.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class ScannedRequest: Codable {
    
    public init() {}
    
    public var sub: String = ""
    public var exchange_id: String = ""
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_id: String = ""
}
