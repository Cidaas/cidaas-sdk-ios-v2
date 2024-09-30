//
//  DeleteDeviceRequest.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation

public class DeleteDeviceRequest: Codable {
    
    // properties
    public var client_id: String = ""
    public var push_id: String = ""
    public var sub: String = ""
    public var device_id: String = ""

    // constructor
    public init() {}
}
