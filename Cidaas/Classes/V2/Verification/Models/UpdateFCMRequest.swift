//
//  UpdateFCMRequest.swift
//  Cidaas
//
//  Created by ganesh on 23/05/19.
//

import Foundation

public class UpdateFCMRequest: Codable {
    
    public init() {}
    
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_id: String = ""
    public var old_push_id: String = ""
}
