//
//  ConsentDetailsV2RequestEntity.swift
//  Cidaas
//
//  Created by ganesh on 03/04/19.
//

import Foundation

public class ConsentDetailsRequestEntity : Codable {
    // properties
    public var consent_id: String = ""
    public var sub: String = ""
    public var consent_version_id: String = ""
    public var requestId: String = ""
    public var track_id: String = ""
    public var client_id: String = ""
    
    // Constructors
    public init() {
        
    }
}



