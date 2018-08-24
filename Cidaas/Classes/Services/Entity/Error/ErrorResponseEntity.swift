//
//  ErrorResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ErrorResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var error:ErrorResponseDataEntity = ErrorResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
}


public class ErrorResponseDataEntity : Codable {
    // properties
    public var error: String = ""
    
    // Constructors
    public init() {
        
    }
}
