//
//  AcceptConsentV2Entity.swift
//  Cidaas
//
//  Created by ganesh on 03/04/19.
//

import Foundation

public class AcceptConsentEntity : Codable {
    // properties
    public var consent_id: String = ""
    public var client_id: String = ""
    public var sub: String = ""
    public var consent_version_id: String = ""
    
    // Constructors
    public init() {
        
    }
}
