//
//  InitiateResetPasswordEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class InitiateResetPasswordEntity : Codable {
    
    // properties
    public var resetMedium: String = ""
    public var requestId: String = ""
    public var processingType: String = ""
    public var mobile: String = ""
    public var email: String = ""
    
    // Constructors
    public init() {
        
    }
}
