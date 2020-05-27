//
//  LoginEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class LoginEntity : Codable {
    // properties
    public var username: String = ""
    public var password: String = ""
    public var username_type: String = ""
    public var requestId: String = ""
    public var rememberMe: Bool = false
    
    // Constructors
    public init() {
        
    }
}
