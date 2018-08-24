//
//  ConsentEntity.swift
//  Cidaas
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ConsentEntity : Codable {
    // properties
    public var accepted: Bool = false
    public var sub: String = ""
    public var version: String = ""
    public var consent_name: String = ""
    public var track_id: String = ""
    
    // Constructors
    public init() {
        
    }
}
