//
//  UserLoginInfoEntity.swift
//  Cidaas
//
//  Created by ganesh on 12/03/19.
//

import Foundation

public class UserLoginInfoEntity : Codable {
    // properties
    public var sub: String = ""
    public var skip: Int16 = 0
    public var take: Int16 = 0
    public var verificationType: String = ""
    public var startDate: String = ""
    public var endDate: String = ""
    public var status: String = ""
    
    // Constructors
    public init() {
        
    }
}
