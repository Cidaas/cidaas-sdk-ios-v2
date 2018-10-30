//
//  UserActivityEntity.swift
//  Cidaas
//
//  Created by ganesh on 10/08/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class UserActivityEntity : Codable {
    // properties
    public var sub: String = ""
    public var skip: Int16 = 0
    public var take: Int16 = 0
    
    // Constructors
    public init() {
        
    }
}
