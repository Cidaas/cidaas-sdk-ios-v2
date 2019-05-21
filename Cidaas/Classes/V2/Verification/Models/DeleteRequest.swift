//
//  DeleteAllRequest.swift
//  Cidaas
//
//  Created by ganesh on 20/05/19.
//

import Foundation

public class DeleteRequest: Codable {
    
    public init() {}
    
    public var device_id: String = ""
    public var push_id: String = ""
    public var sub: String = ""
    public var verificationType: String = ""
}
