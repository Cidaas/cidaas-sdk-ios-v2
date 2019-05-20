//
//  EnrollRequest.swift
//  Cidaas
//
//  Created by ganesh on 07/05/19.
//

import Foundation

public class EnrollRequest: Codable {
    
    public init() {}
    
    public var exchange_id: String = ""
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_id: String = ""
    public var pass_code: String = ""
    public var attempt: Int = 0
    public var localizedReason: String = ""
}
