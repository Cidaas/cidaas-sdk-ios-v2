//
//  ConsentDetailsResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class ConsentDetailsResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: ConsentDetailsResponseDataEntity = ConsentDetailsResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(ConsentDetailsResponseDataEntity.self, forKey: .data) ?? ConsentDetailsResponseDataEntity()
    }
}

public class ConsentDetailsResponseDataEntity : Codable {
    // properties
    public var sensitive: Bool = false
    public var policyUrl: String = ""
    public var userAgreeText: String = ""
    public var description: String = ""
    public var name: String = ""
    public var language: String = ""
    public var consentReceiptID: String = ""
    public var collectionMethod: String = ""
    public var jurisdiction: String = ""
    public var enabled: Bool = false
    public var consent_type: String = ""
    public var status: String = ""
    public var spiCat: [String] = []
    public var services: [ConsentDetailsResponseDataSettingsReponseServiceEntity] = []
    public var piiControllers: [ConsentDetailsResponseDataPIIControllersEntity] = []
    public var version: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sensitive = try container.decodeIfPresent(Bool.self, forKey: .sensitive) ?? false
        self.policyUrl = try container.decodeIfPresent(String.self, forKey: .policyUrl) ?? ""
        self.userAgreeText = try container.decodeIfPresent(String.self, forKey: .userAgreeText) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.consentReceiptID = try container.decodeIfPresent(String.self, forKey: .consentReceiptID) ?? ""
        self.collectionMethod = try container.decodeIfPresent(String.self, forKey: .collectionMethod) ?? ""
        self.jurisdiction = try container.decodeIfPresent(String.self, forKey: .jurisdiction) ?? ""
        self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? false
        self.consent_type = try container.decodeIfPresent(String.self, forKey: .consent_type) ?? ""
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.spiCat = try container.decodeIfPresent([String].self, forKey: .spiCat) ?? []
        self.services = try container.decodeIfPresent([ConsentDetailsResponseDataSettingsReponseServiceEntity].self, forKey: .services) ?? []
        self.piiControllers = try container.decodeIfPresent([ConsentDetailsResponseDataPIIControllersEntity].self, forKey: .piiControllers) ?? []
        self.version = try container.decodeIfPresent(String.self, forKey: .version) ?? ""
    }
}

public class ConsentDetailsResponseDataPIIControllersEntity : Codable {
    // properties
    public var piiController: String = ""
    public var onBehalf: Bool = false
    public var contact: String = ""
    public var address: ConsentDetailsResponseDataPIIControllersAddressEntity = ConsentDetailsResponseDataPIIControllersAddressEntity()
    public var email: String = ""
    public var phone: String = ""
    
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.piiController = try container.decodeIfPresent(String.self, forKey: .piiController) ?? ""
        self.onBehalf = try container.decodeIfPresent(Bool.self, forKey: .onBehalf) ?? false
        self.contact = try container.decodeIfPresent(String.self, forKey: .contact) ?? ""
        self.address = try container.decodeIfPresent(ConsentDetailsResponseDataPIIControllersAddressEntity.self, forKey: .address) ?? ConsentDetailsResponseDataPIIControllersAddressEntity()
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
    }
}

public class ConsentDetailsResponseDataPIIControllersAddressEntity : Codable {
    // properties
    public var streetAddress: String = ""
    public var addressCountry: String = ""
    
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.streetAddress = try container.decodeIfPresent(String.self, forKey: .streetAddress) ?? ""
        self.addressCountry = try container.decodeIfPresent(String.self, forKey: .addressCountry) ?? ""
    }
}

public class ConsentDetailsResponseDataSettingsReponseServiceEntity : Codable {
    // properties
    public var service: String = ""
    public var purposes: [ConsentDetailsResponseDataSettingsServicePurposeEntity] = []
    
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.service = try container.decodeIfPresent(String.self, forKey: .service) ?? ""
        self.purposes = try container.decodeIfPresent([ConsentDetailsResponseDataSettingsServicePurposeEntity].self, forKey: .purposes) ?? []
    }
}

public class ConsentDetailsResponseDataSettingsServicePurposeEntity : Codable {
    // properties
    public var purpose: String = ""
    public var purposeCategory: String = ""
    public var consentType: String = ""
    public var piiCategory: String = ""
    public var primaryPurpose: Bool = false
    public var termination: String = ""
    public var thirdPartyDisclosure: Bool = false
    public var thirdPartyName: String = ""
    
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.purpose = try container.decodeIfPresent(String.self, forKey: .purpose) ?? ""
        self.purposeCategory = try container.decodeIfPresent(String.self, forKey: .purposeCategory) ?? ""
        self.consentType = try container.decodeIfPresent(String.self, forKey: .consentType) ?? ""
        self.piiCategory = try container.decodeIfPresent(String.self, forKey: .piiCategory) ?? ""
        self.primaryPurpose = try container.decodeIfPresent(Bool.self, forKey: .primaryPurpose) ?? false
        self.termination = try container.decodeIfPresent(String.self, forKey: .termination) ?? ""
        self.thirdPartyDisclosure = try container.decodeIfPresent(Bool.self, forKey: .thirdPartyDisclosure) ?? false
        self.thirdPartyName = try container.decodeIfPresent(String.self, forKey: .thirdPartyName) ?? ""
    }
}
