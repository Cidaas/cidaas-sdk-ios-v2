//
//  PasswordlessEntity.swift
//  Cidaas
//
//  Created by ganesh on 02/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class PasswordlessEntity : Codable {
    // properties
    public var email: String = ""
    public var mobile: String = ""
    public var sub: String = ""
    public var requestId: String = ""
    public var trackId: String = ""
    public var usageType: String = ""
    
    // Constructors
    public init() {
        
    }
}
