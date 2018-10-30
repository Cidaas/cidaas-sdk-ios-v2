//
//  UserInfoModel.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class UserInfoModel : Codable {
    
    // shared instance
    public static var shared : UserInfoModel = UserInfoModel()
    
    // properties
    public var provider: String = ""
    public var userId: String = ""
    public var userName: String = ""
    public var email: String = "'"
    public var mobile: String = ""
    public var firstName: String = ""
    public var lastName: String = ""
    public var displayName: String = ""
    public var active: Bool = false
    public var emailVerified: Bool = false
    public var mobileNoVerified: Bool = false
    
    // Constructors
    public init() {
        
    }
}
