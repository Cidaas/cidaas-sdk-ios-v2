//
//  HandleResetPasswordEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class HandleResetPasswordEntity : Codable {
    
    // properties
    public var code: String = ""
    public var resetRequestId: String = ""
    
    // Constructors
    public init() {
        
    }
}
