//
//  MFAContinueEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class MFAContinueEntity : Codable {
    // properties
    public var trackingCode: String = ""
    public var trackId: String = ""
    public var sub: String = ""
    public var requestId: String = ""
    public var verificationType: String = ""
    
    // Constructors
    public init() {
        
    }
}
