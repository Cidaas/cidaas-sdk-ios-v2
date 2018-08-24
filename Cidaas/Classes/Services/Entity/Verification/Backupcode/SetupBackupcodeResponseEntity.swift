//
//  SetupBackupcodeResponseEntity.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class SetupBackupcodeResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: SetupBackupcodeResponseDataEntity = SetupBackupcodeResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(SetupBackupcodeResponseDataEntity.self, forKey: .data) ?? SetupBackupcodeResponseDataEntity()
    }
}

public class SetupBackupcodeResponseDataEntity : Codable {
    // properties
    public var statusId: String = ""
    public var backupCodes: [SetupBackupcodeResponseDataBackupcodeEntity] = []
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.backupCodes = try container.decodeIfPresent([SetupBackupcodeResponseDataBackupcodeEntity].self, forKey: .backupCodes) ?? []
    }
}

public class SetupBackupcodeResponseDataBackupcodeEntity : Codable {
    // properties
    public var statusId: String = ""
    public var code: String = ""
    public var used: Bool = false
    public var usedDeviceInfo: SetupBackupcodeResponseDataBackupcodeDeviceInfoEntity = SetupBackupcodeResponseDataBackupcodeDeviceInfoEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusId = try container.decodeIfPresent(String.self, forKey: .statusId) ?? ""
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.used = try container.decodeIfPresent(Bool.self, forKey: .used) ?? false
        self.usedDeviceInfo = try container.decodeIfPresent(SetupBackupcodeResponseDataBackupcodeDeviceInfoEntity.self, forKey: .used) ?? SetupBackupcodeResponseDataBackupcodeDeviceInfoEntity()
    }
}

public class SetupBackupcodeResponseDataBackupcodeDeviceInfoEntity : Codable {
    // properties
    public var userDeviceId: String = ""
    public var userAgent: String = ""
    public var usedTime: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userDeviceId = try container.decodeIfPresent(String.self, forKey: .userDeviceId) ?? ""
        self.userAgent = try container.decodeIfPresent(String.self, forKey: .userAgent) ?? ""
        self.usedTime = try container.decodeIfPresent(String.self, forKey: .usedTime) ?? ""
    }
}
