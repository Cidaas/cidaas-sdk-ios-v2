//
//  RegistrationEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class RegistrationEntity : Codable {
    
    // properties
    public var email: String = ""
    public var given_name: String = ""
    public var family_name: String = ""
    public var username: String = ""
    public var password: String = ""
    public var password_echo: String = ""
    public var provider: String = ""
    public var mobile_number: String = ""
    public var birthdate: String = ""
    public var identityId: String = ""
    public var sub: String = ""
    public var customFields: Dictionary<String, RegistrationCustomFieldsEntity> = Dictionary<String, RegistrationCustomFieldsEntity>()
    
    public init() {
        
    }
    
}

public class RegistrationCustomFieldsEntity : Codable {
    
    // properties
    public var id: String = ""
    public var dataType: String = ""
    public var value: String = ""
    public var readOnly: Bool = false
    public var lastUpdateFrom: String = ""
    public var key: String = ""
    
    public init() {
        
    }
}
