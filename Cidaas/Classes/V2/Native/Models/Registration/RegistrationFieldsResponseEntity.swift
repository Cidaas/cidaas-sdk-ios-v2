//
//  RegistrationFieldsResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 27/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class RegistrationFieldsResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: [RegistrationFieldsResponseDataEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([RegistrationFieldsResponseDataEntity].self, forKey: .data) ?? []
    }
}

public class RegistrationFieldsResponseDataEntity : Codable {
    // properties
    public var dataType: String = ""
    public var fieldGroup: String = ""
    public var isGroupTitle: Bool = false
    public var fieldKey: String = ""
    public var fieldType: String = ""
    public var order: Int16 = 0
    public var readOnly: Bool = false
    public var required: Bool = false
    public var fieldDefinition: RegistrationFieldsResponseDataFieldDefinitionEntity = RegistrationFieldsResponseDataFieldDefinitionEntity()
    public var localeText: RegistrationFieldsResponseDataLocaleTextEntity = RegistrationFieldsResponseDataLocaleTextEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dataType = try container.decodeIfPresent(String.self, forKey: .dataType) ?? ""
        self.fieldGroup = try container.decodeIfPresent(String.self, forKey: .fieldGroup) ?? ""
        self.isGroupTitle = try container.decodeIfPresent(Bool.self, forKey: .isGroupTitle) ?? false
        self.fieldKey = try container.decodeIfPresent(String.self, forKey: .fieldKey) ?? ""
        self.fieldType = try container.decodeIfPresent(String.self, forKey: .fieldType) ?? ""
        self.order = try container.decodeIfPresent(Int16.self, forKey: .order) ?? 0
        self.readOnly = try container.decodeIfPresent(Bool.self, forKey: .readOnly) ?? false
        self.required = try container.decodeIfPresent(Bool.self, forKey: .required) ?? false
        self.fieldDefinition = try container.decodeIfPresent(RegistrationFieldsResponseDataFieldDefinitionEntity.self, forKey: .fieldDefinition) ?? RegistrationFieldsResponseDataFieldDefinitionEntity()
        self.localeText = try container.decodeIfPresent(RegistrationFieldsResponseDataLocaleTextEntity.self, forKey: .localeText) ?? RegistrationFieldsResponseDataLocaleTextEntity()
    }
}

public class RegistrationFieldsResponseDataFieldDefinitionEntity : Codable {
    // properties
    public var maxLength: Int16 = 0
    public var minLength: Int16 = 0
    public var matchWith: String = ""
    public var applyPasswordPoly: Bool = false
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.maxLength = try container.decodeIfPresent(Int16.self, forKey: .maxLength) ?? 0
        self.minLength = try container.decodeIfPresent(Int16.self, forKey: .minLength) ?? 0
        self.matchWith = try container.decodeIfPresent(String.self, forKey: .matchWith) ?? ""
        self.applyPasswordPoly = try container.decodeIfPresent(Bool.self, forKey: .applyPasswordPoly) ?? false
    }
}

public class RegistrationFieldsResponseDataLocaleTextEntity : Codable {
    // properties
    public var locale: String = ""
    public var language: String = ""
    public var name: String = ""
    public var required: String = ""
    public var maxLength: String = ""
    public var matchWith: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locale = try container.decodeIfPresent(String.self, forKey: .locale) ?? ""
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.required = try container.decodeIfPresent(String.self, forKey: .required) ?? ""
        self.maxLength = try container.decodeIfPresent(String.self, forKey: .maxLength) ?? ""
        self.matchWith = try container.decodeIfPresent(String.self, forKey: .matchWith) ?? ""
    }
}
