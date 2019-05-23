//
//  AuthenticatedHistoryRequest.swift
//  Cidaas
//
//  Created by ganesh on 23/05/19.
//

import Foundation

public class AuthenticatedHistoryRequest: Codable {
    
    public init() {}
    
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_id: String = ""
    public var sub: String = ""
    public var skip: Int16 = 0
    public var take: Int16 = 0
    public var verificationType: String = ""
    public var start_time: String = ""
    public var end_time: String = ""
}
