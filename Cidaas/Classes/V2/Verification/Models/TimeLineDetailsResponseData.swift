//
//  TimeLineDetailsResponseData.swift
//  Cidaas
//
//  Created by ganesh on 21/05/19.
//

import Foundation

public class TimeLineDetailsResponseData: Codable {
    
    // properties    
    public var _id: String = ""
    public var status_id: String = ""
    public var ph_id: String = ""
    public var verification_type: String = ""
    public var status: String = ""
    public var client_id: String = ""
    public var device_info: String = ""
    public var location_details: String = ""
    public var request_id: String = ""
    public var usage_type: String = ""
    public var createdTime: String = ""
    public var id: String = ""
    
    // constructor
    public init() {}
}
