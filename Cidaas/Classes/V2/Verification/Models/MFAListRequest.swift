//
//  MFAListRequest.swift
//  Cidaas
//
//  Created by ganesh on 21/05/19.
//

import Foundation

public class MFAListRequest: Codable {
    
    public init() {}
    
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_id: String = ""
    public var sub: String = ""
}
