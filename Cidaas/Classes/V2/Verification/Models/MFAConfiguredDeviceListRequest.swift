//
//  MFAConfiguredDeviceListRequest.swift
//  Cidaas
//
//  Created by Widas Ganesh RH on 12/03/24.
//

import Foundation

public class MFAConfiguredDeviceListRequest: Codable {
    
    // properties
    public var client_id: String = ""
    public var push_id: String = ""
    public var sub: [String] = []

    // constructor
    public init() {}
}
