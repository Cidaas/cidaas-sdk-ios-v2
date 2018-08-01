//
//  ConsentContinueEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ConsentContinueEntity : Codable {
    // properties
    public var client_id: String = ""
    public var trackId: String = ""
    public var sub: String = ""
    public var version: Int16 = 0
    public var name: String = ""
    
    // Constructors
    public init() {
        
    }
}
