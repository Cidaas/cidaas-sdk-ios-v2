//
//  TOTP.swift
//  Cidaas
//
//  Created by ganesh on 30/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class TOTP : Codable {
    public var name: String = ""
    public var issuer: String = ""
    public var timer_count: String = ""
    public var totp_string: String = ""
    
    public init() {
        
    }
}
