//
//  EnrollDocumentResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 30/10/18.
//

import Foundation

public class EnrollDocumentResponseEntity : Codable {
    // properties
    public var success: Bool = false
    public var status: Int16 = 400
    public var data: EnrollDocumentResponseDataEntity = EnrollDocumentResponseDataEntity()
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent(EnrollDocumentResponseDataEntity.self, forKey: .data) ?? EnrollDocumentResponseDataEntity()
    }
}

public class EnrollDocumentResponseDataEntity : Codable {
    // properties
    public var Place: String = ""
    public var Name: String = ""
    public var Vorname: String = ""
    public var No: String = ""
    public var Geb: String = ""
    
    // Constructors
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.Place = try container.decodeIfPresent(String.self, forKey: .Place) ?? ""
        self.Name = try container.decodeIfPresent(String.self, forKey: .Name) ?? ""
        self.Vorname = try container.decodeIfPresent(String.self, forKey: .Vorname) ?? ""
        self.No = try container.decodeIfPresent(String.self, forKey: .No) ?? ""
        self.Geb = try container.decodeIfPresent(String.self, forKey: .Geb) ?? ""
    }
}
