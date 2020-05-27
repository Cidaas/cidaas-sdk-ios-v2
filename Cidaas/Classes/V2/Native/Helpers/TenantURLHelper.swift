//
//  TenantURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class TenantURLHelper {
    
    public static var shared : TenantURLHelper = TenantURLHelper()
    
    public var tenantInfoURL = "/public-srv/tenantinfo/basic"
    
    public func getTenantInfoURL() -> String {
        return tenantInfoURL
    }
}
