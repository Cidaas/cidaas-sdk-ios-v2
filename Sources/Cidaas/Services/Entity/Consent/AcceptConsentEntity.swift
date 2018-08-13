//
//  AcceptConsentEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AcceptConsentEntity : Codable {
    // properties
    public var name: String = ""
    public var client_id: String = ""
    public var sub: String = ""
    public var version: String = ""
    public var accepted: Bool = false
    
    // Constructors
    public init() {
        
    }
}
