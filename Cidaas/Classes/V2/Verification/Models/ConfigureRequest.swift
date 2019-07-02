//
//  ConfigureRequest.swift
//  Cidaas
//
//  Created by ganesh on 07/06/19.
//

import Foundation

public class ConfigureRequest: Codable {
    
    public init() {}
    
    public var access_token: String = ""
    public var sub: String = ""
    public var verificationType: String = ""
    public var pass_code: String = ""
    public var attempt: Int = 0
    public var localizedReason: String = ""
}
