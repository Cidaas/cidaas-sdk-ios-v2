//
//  PushAcknowledgeRequest.swift
//  Cidaas
//
//  Created by ganesh on 08/05/19.
//

import Foundation

public class PushAcknowledgeRequest: Codable {
    
    public init() {}
    
    public var exchange_id: String = ""
    public var push_id: String = ""
    public var device_id: String = ""
    public var client_id: String = ""
}
