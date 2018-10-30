//
//  AccessTokenModel.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class AccessTokenModel : Codable {
    
    // shared instance
    public static var shared : AccessTokenModel = AccessTokenModel()
    
    // properties
    public var accessToken: String = ""
    public var userState: String = ""
    public var refreshToken: String = ""
    public var scope: String = ""
    public var idToken: String = ""
    public var expiresIn: Int64 = 0
    public var isEncrypted: Bool = false
    public var salt: String = ""
    public var userId: String = ""
    public var seconds: Int64 = 0
    public var plainToken : String = ""
    
    // Constructors
    public init() {
        
    }
}
