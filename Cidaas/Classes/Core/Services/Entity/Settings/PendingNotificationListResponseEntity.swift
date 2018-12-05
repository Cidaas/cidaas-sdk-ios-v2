//
//  PendingNotificationListResponseEntity.swift
//  Cidaas
//
//  Created by ganesh on 30/11/18.
//

import Foundation

public class PendingNotificationListResponseEntity : Codable {
    public var success : Bool = false
    public var status : Int16 = 400
    public var data : [PushNotificationEntity] = []
    
    public init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 400
        self.data = try container.decodeIfPresent([PushNotificationEntity].self, forKey: .data) ?? []
    }
}
