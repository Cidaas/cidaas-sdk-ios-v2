//
//  ResetPasswordEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ResetPasswordEntity : Codable {
    
    // properties
    public var password: String = ""
    public var confirmPassword: String = ""
    public var exchangeId: String = ""
    public var resetRequestId: String = ""
    
    // Constructors
    public init() {
        
    }
}
