//
//  SettingsURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class SettingsURLHelper {
    
    public static var shared : SettingsURLHelper = SettingsURLHelper()
    
    public var endpointsURL = "/.well-known/openid-configuration"
    
    public func getEndpointsURL() -> String {
        return endpointsURL
    }
}
