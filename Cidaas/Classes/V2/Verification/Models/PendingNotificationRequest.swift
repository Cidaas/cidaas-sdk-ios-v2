//
//  PendingNotificationRequest.swift
//  Alamofire
//
//  Created by ganesh on 23/05/19.
//

import Foundation

public class PendingNotificationRequest: Codable {
    
    public init() {}
    
    public var device_id: String = ""
    public var client_id: String = ""
    public var push_id: String = ""
    public var sub: String = ""
}
