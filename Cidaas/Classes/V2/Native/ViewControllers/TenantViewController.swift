//
//  TenantViewController.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class TenantViewController {
    
    public static var shared: TenantViewController = TenantViewController()
    var sharedInteractor: TenantInteractor
    
    public init() {
        sharedInteractor = TenantInteractor.shared
    }
    
    // Tenant Info
    public func getTenantInfo(callback: @escaping(Result<TenantInfoResponseEntity>) -> Void) {
        sharedInteractor.getTenantInfo(callback: callback)
    }
}
