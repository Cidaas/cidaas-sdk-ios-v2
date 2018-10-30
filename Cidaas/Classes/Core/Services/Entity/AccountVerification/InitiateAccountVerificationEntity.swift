//
//  InitiateAccountVerificationEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class InitiateAccountVerificationEntity : Codable {
    // properties
    public var verificationMedium: String = ""
    public var requestId: String = ""
    public var processingType: String = ""
    public var sub: String = ""
    
    // Constructors
    public init() {
        
    }
}
